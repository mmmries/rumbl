defmodule Rumbl.Video do
  use Rumbl.Web, :model

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    belongs_to :user, Rumbl.User

    timestamps
  end

  @required_fields ~w(url title description)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:url, &String.downcase/1)
    |> update_change(:url, &String.strip/1)
    |> validate_length(:title, min: 5, max: 255)
    |> validate_length(:description, min: 0, max: 4096)
  end
end
