defmodule Tunez.Repo.Migrations.AddUserLinksToArtistsAndAlbums2 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    rename table(:artists), :updated_eby_id, to: :updated_by_id

    drop constraint(:artists, "artists_updated_eby_id_fkey")

    alter table(:artists) do
      modify :updated_by_id,
             references(:users,
               column: :id,
               name: "artists_updated_by_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    rename table(:albums), :updated_eby_id, to: :updated_by_id

    drop constraint(:albums, "albums_updated_eby_id_fkey")

    alter table(:albums) do
      modify :updated_by_id,
             references(:users,
               column: :id,
               name: "albums_updated_by_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end
  end

  def down do
    drop constraint(:albums, "albums_updated_by_id_fkey")

    alter table(:albums) do
      modify :updated_eby_id,
             references(:users,
               column: :id,
               name: "albums_updated_eby_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    rename table(:albums), :updated_by_id, to: :updated_eby_id

    drop constraint(:artists, "artists_updated_by_id_fkey")

    alter table(:artists) do
      modify :updated_eby_id,
             references(:users,
               column: :id,
               name: "artists_updated_eby_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    rename table(:artists), :updated_by_id, to: :updated_eby_id
  end
end
