defmodule Rumbl.AnnotationView do
  use Rumbl.Web, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: Rumbl.UserView.render("user.json", annotation.user),
    }
  end

  def render("annotation_with_user.json", annotation, user) do
    %{
      user: Rumbl.UserView.render("user.json", user),
      body: annotation.body,
      at: annotation.at,
    }
  end
end
