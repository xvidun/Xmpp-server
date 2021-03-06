defmodule ModPacketInterceptor do
  import Ejabberd.Logger
  @behaviour :gen_mod
  alias Spotlight.Repo
  alias Spotlight.User
  alias Spotlight.Bot

  def start(host, _opts) do
    info('Starting ejabberd module ModPacketInterceptor')
    Ejabberd.Hooks.add(:filter_packet, :global, __ENV__.module, :on_filter_packet, 50)
    :ok
  end

  def stop(_host) do
    info('Stopping ejabberd module ModPacketInterceptor')
    Ejabberd.Hooks.delete(:filter_packet, :global, __ENV__.module, :on_filter_packet, 50)
    :ok
  end

  def on_filter_packet({from, to, xml} = packet) do
  	info("Received packet: #{inspect {from, to, xml}}")
    {:jid, jid_from, _, _, _, _, _} = from
    case {to, jid_from, xml} do
      { {:jid, "o_"<>id, _host, _, _, _, _}, "u_"<>userid_from,  {:xmlel, "message" , _ , [ {:xmlel,"body",_, [xmlcdata: message] } ,_, _ ]} }->
      		bot_user = Repo.get_by(User, [username: "o_"<>id]) |> Repo.preload([:bot_details])

          case BotHelper.forward_message(userid_from, message, bot_user.bot_details.post_url) do
            {:ok, _} ->
              #Message Delivered
              info("Delivered '#{message}' to #{bot_user.bot_details.post_url} ")
            {:error, m} ->
              #Error sending message
              info("Error forwading '#{message}' to #{bot_user.bot_details.post_url} ")
          end

          #Temporary for team ichat receive messages.
          case id do
             "teamichat" ->
                  info("Team ichat message")
               packet
             _ ->
                  info("Dropping message")
               :drop
          end
      _ ->
        info("Pass message: #{inspect {from, to, xml}}")
        packet
    end
  end
end
