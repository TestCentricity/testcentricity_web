# Page Object class definition for Basic HTML Form page with Xpath locators

class BasicXpathFormPage < BasicFormPage
  trait(:page_name)    { 'Basic Xpath Form' }
  trait(:page_locator) { "//form[@id='HTMLFormElements']" }

  # Basic HTML Test page UI elements
  textfields  username_field:    "//input[@id='username']",
              password_field:    "//input[@id='password']",
              max_length_field:  "//input[@id='maxlength']",
              read_only_field:   "//input[@id='readonly']",
              number_int_field:  "//input[@id='number-int-field']",
              number_flt_field:  "//input[@id='number-float-field']",
              date_field:        "//input[@id='date-picker']",
              date_time_field:   "//input[@id='date-time-picker']",
              email_field:       "//input[@id='email-field']",
              month_field:       "//input[@id='month-field']",
              comments_field:    "//textarea[@id='comments']",
              color_picker:      "//input[@id='color-picker']"
  ranges      slider:            "//input[@id='slider']"
  filefields  upload_file:       "//input[@id='filename']"
  checkboxes  check_1:           "//input[@id='check1']",
              check_2:           "//input[@id='check2']",
              check_3:           "//input[@id='check3']",
              check_4:           "//input[@id='check4']"
  radios      radio_1:           "//input[@id='radio1']",
              radio_2:           "//input[@id='radio2']",
              radio_3:           "//input[@id='radio3']",
              radio_4:           "//input[@id='radio4']"
  selectlists multi_select:      "//select[@id='multipleselect']",
              drop_down_select:  "//select[@id='dropdown']"
  lists       links_list:        "//ul[@id='links_list']"
  links       link_1:            "//a[@id='link1']",
              link_2:            "//a[@id='link2']",
              link_3:            "//a[@id='link3']"
  tables      static_table:      "//table[@id='table']"
  images      image_upload:      "//img[@id='output']",
              image_1:           "//img[@id='image1']",
              image_2:           "//img[@id='image2']",
              image_3:           "//img[@id='image3']",
              image_4:           "//img[@id='image4']"
  buttons     progress_button:   "//button[@id='run-progress']",
              cancel_button:     "//input[@id='cancel']",
              submit_button:     "//input[@id='submit']"
  labels      header_label:      '//h2',
              username_label:    "//label[@for='username']",
              password_label:    "//label[@for='password']",
              max_length_label:  "//label[@for='maxlength']",
              read_only_label:   "//label[@for='readonly']",
              number_int_label:  "//label[@for='number-int-field']",
              number_flt_label:  "//label[@for='number-float-field']",
              color_label:       "//label[@for='color-picker']",
              slider_label:      "//label[@for='slider']",
              comments_label:    "//label[@for='comments']",
              filename_label:    "//label[@for='filename']",
              checkboxes_label:  "//label[@id='checkboxes']",
              radios_label:      "//label[@id='radios']",
              multiselect_label: "//label[@for='multipleselect']",
              dropdown_label:    "//label[@for='dropdown']",
              link_label:        "//label[@id='links']",
              table_label:       "//label[@for='table']",
              images_label:      "//label[@id='images']"
  elements    progress_bar:      "//progress[@id='progress-bar']",
              tooltip_1:         "//span[@id='tip1']",
              tooltip_2:         "//span[@id='tip2']",
              tooltip_3:         "//span[@id='tip3']"
end
