defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :biography, :string

    attribute :previous_names, {:array, :string} do
      default []
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  actions do
    create :create do
      accept [:name, :biography]
    end

    read :read do
      primary? true
    end

    update :update do
      require_atomic? false
      accept [:name, :biography]

      change fn changeset, _context ->
        new_name = Ash.Changeset.get_attribute(changeset, :name)
        previous_name = Ash.Changeset.get_data(changeset, :name)
        previous_names = Ash.Changeset.get_data(changeset, :previous_names)

        names = [previous_name | previous_names]
          |> Enum.uniq()
          |> Enum.reject(fn name -> name == new_name end)

        Ash.Changeset.change_attribute(changeset, :previous_names, names)
      end,
        where: [changing(:name)]
    end

    destroy :destroy
  end

  postgres do
    table "artists"
    repo Tunez.Repo
  end
end
