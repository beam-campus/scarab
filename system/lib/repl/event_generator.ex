defmodule ExESDB.Repl.EventGenerator do
  @moduledoc false

  require UUID

  @initialized_v1 "initialized:v1"
  
  @temperature_measured_v1 "temperature_measured:v1"
  @humidity_measured_v1 "humidity_measured:v1"
  @light_measured_v1 "light_measured:v1"
  
  @fan_activated_v1 "fan_activated:v1"
  @fan_deactivated_v1 "fan_deactivated:v1"
  @light_activated_v1 "light_activated:v1"
  @light_deactivated_v1 "light_deactivated:v1"
  @heater_activated_v1 "heater_activated:v1"
  @heater_deactivated_v1 "heater_deactivated:v1"
  @sprinkler_activated_v1 "sprinkler_activated:v1"
  @sprinkler_deactivated_v1 "sprinkler_deactivated:v1"

  @desired_temperature_set_v1 "desired_temperature_set:v1"
  @desired_humidity_set_v1 "desired_humidity_set:v1"
  @desired_light_set_v1 "desired_light_set:v1"

  @event_types [
    @initialized_v1,
 
    @temperature_measured_v1,
    @humidity_measured_v1,
    @light_measured_v1,

    @desired_temperature_set_v1,
    @desired_humidity_set_v1,
    @desired_light_set_v1,

    @light_activated_v1,
    @light_deactivated_v1,
    @fan_activated_v1,
    @fan_deactivated_v1,
    @heater_activated_v1,
    @heater_deactivated_v1,
    @sprinkler_activated_v1,
    @sprinkler_deactivated_v1,
  ]


  @operators [
    "John",
    "Paul",
    "George",
    "Ringo",
  ]

  # Example content type values
  @content_types [1, 2, 3]

  defp random_operator, do: Enum.random(@operators)
  defp random_temperature, do: 5 + :rand.uniform(30)
  defp random_humidity, do:  :rand.uniform(100)
  defp random_light, do:  :rand.uniform(100)
  defp random_intensity, do:  :rand.uniform(100)

  def initialize(),
    do:
    %ExESDB.NewEvent{
      event_id: generate_uuid(),
      event_type: @initialized_v1,
      data_content_type: 1,
      metadata_content_type: 1,
      data: %{
       temperature: random_temperature(),
       humidity: random_humidity(),
       light: random_light()
       }
    }

  def generate_events(count)
      when is_integer(count) and count > 0,
      do:
        1..count
        |> Enum.map(&generate_event/1)

  defp generate_event(_) do
    event_id = generate_uuid()
    event_type = Enum.random(@event_types)

    %ExESDB.NewEvent{
      event_id: event_id,
      event_type: event_type,
      data_content_type: Enum.random(@content_types),
      metadata_content_type: Enum.random(@content_types),
      data: random_payload(event_type),
      metadata: generate_optional_metadata()
    }
  end

  defp generate_uuid, do: UUID.uuid4()
  defp random_payload(@temperature_measured_v1),
    do: %{
      temperature: random_temperature(),
    }
  defp random_payload(@humidity_measured_v1),
    do: %{
      humidity: random_humidity(),
    }

  defp random_payload(@light_measured_v1),
    do: %{
      light: random_light(),
    }
  defp random_payload(@desired_temperature_set_v1),
    do: %{
      temperature: random_temperature(),
      operator: random_operator()
    }
  defp random_payload(@desired_humidity_set_v1),
    do: %{
      humidity: random_humidity(),
      operator: random_operator()
    }
  defp random_payload(@desired_light_set_v1),
    do: %{
      light: random_light(),
      operator: random_operator()
    }
  defp random_payload(_),
    do: %{
      intensity: random_intensity(),
    }

  defp generate_random_bytes(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64()
  end

  defp generate_optional_metadata do
    # 70% chance of metadata
    if :rand.uniform() < 0.7 do
      generate_random_bytes(128)
    end
  end
end
