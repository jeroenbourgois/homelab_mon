defmodule HomelabMon.Emails do
  import Swoosh.Email

  def solar_edge_down() do
    new()
    |> to({"Jeroen", "jeroen@daele.be"})
    |> from({"HomelabMon", "no-reply@mg.jeroenbourgois.be"})
    |> subject("Solar Edge is down! ☀️ > 🌑")
    |> text_body("Hi man, Solar Edge is down!\n")
  end
end
