# Section Object class definition for Weather Embed iFrame on Custom Controls page

class WeatherEmbed < TestCentricity::PageSection
  trait(:section_locator) { 'iframe#weather_embed' }
  trait(:section_name)    { 'Weather Embed iFrame' }

  # Weather Embed iFrame UI elements
  labels header_label:    'div.embeddable-page-header-text',
         high_temp_label: 'div.signature-temp-hi-lo > span:nth-of-type(1)',
         low_temp_label:  'div.signature-temp-hi-lo > span:nth-of-type(3)',
         wind_label:      'div[class$="column-2"] > div[class$="top"] span.metric-label',
         rain_label:      'div[class$="column-2"] > div[class$="bottom"] span.metric-label',
         humidity_label:  'div[class$="column-3"] > div[class$="top"] span.metric-label',
         barometer_label: 'div[class$="column-3"] > div[class$="bottom"] span.metric-label'

  def verify_embed
    ui = {
      header_label => {
        visible: true,
        caption: 'Canto de Paloma'
      },
      high_temp_label => {
        visible: true,
        caption: { starts_with: 'HIGH: ' }
      },
      low_temp_label => {
        visible: true,
        caption: { starts_with: 'LOW: ' }
      },
      wind_label => {
        visible: true,
        caption: 'Wind:'
      },
      rain_label => {
        visible: true,
        caption: 'Rain:'
      },
      humidity_label => {
        visible: true,
        caption: 'Humidity:'
      },
      barometer_label => {
        visible: true,
        caption: 'Barometer:'
      }
    }
    within_frame(0) do
      verify_ui_states(ui)
    end
  end
end
