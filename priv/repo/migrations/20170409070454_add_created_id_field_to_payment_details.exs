defmodule Spotlight.Repo.Migrations.AddCreatedIdFieldToPaymentDetails do
  use Ecto.Migration

  def change do
    alter table(:payments_details) do
      add :created_by_user_id, :string
    end
  end
end
