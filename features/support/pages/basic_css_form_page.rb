# Page Object class definition for Basic HTML Form page with CSS locators

class BasicCSSFormPage < BasicFormPage
  trait(:page_name)    { 'Basic CSS Form' }
  trait(:page_locator) { 'form#HTMLFormElements' }

  # Basic HTML Test page UI elements
  textfields  username_field:    'input#username',
              password_field:    'input#password',
              max_length_field:  'input#maxlength',
              read_only_field:   'input#readonly',
              number_field:      'input#number-field',
              date_field:        'input#date-picker',
              date_time_field:   'input#date-time-picker',
              email_field:       'input#email-field',
              month_field:       'input#month-field',
              color_picker:      'input#color-picker',
              comments_field:    'textarea#comments'
  ranges      slider:            'input#slider'
  filefields  upload_file:       'input#filename'
  checkboxes  check_1:           'input#check1',
              check_2:           'input#check2',
              check_3:           'input#check3',
              check_4:           'input#check4'
  radios      radio_1:           'input#radio1',
              radio_2:           'input#radio2',
              radio_3:           'input#radio3',
              radio_4:           'input#radio4'
  selectlists multi_select:      'select#multipleselect',
              drop_down_select:  'select#dropdown'
  lists       links_list:        'ul#links_list'
  links       link_1:            'a#link1',
              link_2:            'a#link2',
              link_3:            'a#link3'
  tables      static_table:      'table#table'
  images      image_1:           'img#image1',
              image_2:           'img#image2',
              image_3:           'img#image3'
  buttons     cancel_button:     'input#cancel',
              submit_button:     'input#submit'
  labels      username_label:    "label[for='username']",
              password_label:    "label[for='password']",
              max_length_label:  "label[for='maxlength']",
              read_only_label:   "label[for='readonly']",
              number_label:      "label[for='number-field']",
              color_label:       "label[for='color-picker']",
              slider_label:      "label[for='slider']",
              comments_label:    "label[for='comments']",
              filename_label:    "label[for='filename']",
              checkboxes_label:  'label#checkboxes',
              radios_label:      'label#radios',
              multiselect_label: "label[for='multipleselect']",
              dropdown_label:    "label[for='dropdown']",
              link_label:        'label#links',
              table_label:       "label[for='table']",
              images_label:      'label#images'
end
