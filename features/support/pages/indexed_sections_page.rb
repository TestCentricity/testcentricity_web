# Page Object class definition for Indexed Sections page with CSS locators

class IndexedSectionsPage < BaseTestPage
  trait(:page_name)    { 'Indexed Sections' }
  trait(:page_locator) { 'div.indexed-sections-page-body' }
  trait(:page_url)     { '/indexed_sections_page.html' }
  trait(:navigator)    { header_nav.open_indexed_sections_page }
  trait(:page_title)   { 'Indexed Sections Page'}

  list    :product_list, 'div#product_list'
  section :product_card, ProductCard

  def initialize
    super
    # define the list item element for the Product list object
    list_elements = { list_item: 'div.column' }
    product_list.define_list_elements(list_elements)
    # associate the Product Card indexed section object with the Product list object
    product_card.set_list_index(product_list)
  end

  def verify_page_ui
    super

    product_card.wait_until_visible(5)
    ui = {
      product_list => {
        exists: true,
        visible: true,
        itemcount: 4
      },
      product_card => {
        items: ['Tailored Jeans', 'Faded Short Sleeve T-shirts', 'Print Dress', 'Blouse'],
        all_items_count: 4,
        all_items: ['Tailored Jeans', 'Faded Short Sleeve T-shirts', 'Print Dress', 'Blouse']
      }
    }
    verify_ui_states(ui)
    # verify contents of first product card
    product_card.set_list_index(product_list, 1)
    card_data = {
      product_name: 'Tailored Jeans',
      price: '$59.99',
      description: 'Some text about the jeans. Super slim and comfy lorem ipsum lorem jeansum. Lorem jeamsun denim lorem jeansum.',
      rating: 3,
      image_alt: 'Denim Jeans',
      image_src: 'images/jeans3.jpg'
    }
    product_card.verify_card(card_data)
    # verify contents of second product card
    product_card.set_list_index(product_list, 2)
    card_data = {
      product_name: 'Faded Short Sleeve T-shirts',
      price: '$19.99',
      description: "Faded short sleeve t-shirt with high neckline. Soft and stretchy material for a comfortable fit. Accessorize with a straw hat and you're ready for summer!",
      rating: 4,
      image_alt: 'Faded Short Sleeve T-shirts',
      image_src: 'images/T-shirt.jpg'
    }
    product_card.verify_card(card_data)
  end

  def card_action(action, num)
    product_card.set_list_index(product_list, num)
    product_card.card_action(action)
  end
end
