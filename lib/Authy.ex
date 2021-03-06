defmodule Authy do
  require Logger  
  use HTTPoison.Base

  @expected_fields ~w(
    carrier is_cellphone message seconds_to_expire uuid success
  )

  def process_url(url) do
    "https://api.authy.com/protected/json/phones/verification" <> url
  end

  def api_key do
    Application.get_env(:spotlight_api, :authy_api_token)
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  def send_otp(country_code, phone) do
    Authy.start

    if is_binary(api_key) do
      headers = %{"Content-Type" => "application/x-www-form-urlencoded", "X-Authy-API-Key" => api_key}
      body = {:form, [via: "sms", phone_number: phone, country_code: country_code]}

      case Authy.post("/start", body, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          Logger.info "Authy status: #{200}"
          {:ok, body}
        {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
          {:error, body[:message]}
        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.info "Authy error: #{reason}"
          {:error, reason}
      end
    else
      Logger.warn "Authy API key not configured. Edit 'authy_api_token' in config.exs"
    end
  end

  def verify_otp(country_code, phone, verification_code) do
    Authy.start

    if is_binary(api_key) do
      headers = %{"X-Authy-API-Key" => api_key}

      case Authy.get("/check?phone_number="<>phone<>"&country_code="<>country_code<>"&verification_code="<>verification_code, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, 200, body}
        {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
          {:ok, status, body[:message]}
        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
      end
    end
  end
end