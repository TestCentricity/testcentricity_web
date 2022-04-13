class TestSection < TestCentricity::PageSection
  trait(:section_locator) { 'div#section' }
  trait(:section_name)    { 'Basic Test Section' }

  elements    element1: 'div#element1'
  buttons     button1:  'button#button1'
  textfields  field1:   'input#field1'
  links       link1:    'a#link1'
  ranges      range1:   'input#range1'
  images      image1:   'img#image1'
  radios      radio1:   'input#radio1'
  checkboxes  check1:   'input#check1'
  filefields  file1:    'input#file1'
  labels      label1:   'label#label1'
  tables      table1:   'table#table1'
  selectlists select1:  'select#select1'
  lists       list1:    'ul#list1'
  videos      video1:   'video#video1'
  audios      audio1:   'audio#audio1'
  sections    section2: TestSection
end
