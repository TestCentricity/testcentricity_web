# Section Object class definition for Product Card

class ProductCard < TestCentricity::PageSection
  trait(:section_locator) { 'div.column' }
  trait(:section_name)    { 'Product Card' }

  # Product Card UI elements
  image    :product_image,      'img[data-test-id="product_image"]'
  labels   name_label:          'h1[data-test-id="product_name"]',
           price_label:         'p[data-test-id="price"]',
           description_label:   'p[data-test-id="description"]'
  elements ratings:             'div[data-test-id="rating"]',
           checked_star:        'span.fa.fa-star.checked'
  button   :add_to_cart_button, 'button[data-test-id="add_to_cart"]'

  def get_value(visible = nil)
    name_label.get_caption(visible)
  end

  def verify_card(card_data)
    ui = {
      product_image => {
        visible: true,
        loaded: true,
        broken: false,
        src: { ends_with: card_data[:image_src] },
        alt: card_data[:image_alt]
      },
      name_label         => { visible: true, caption: card_data[:product_name] },
      price_label        => { visible: true, caption: card_data[:price] },
      description_label  => { visible: true, caption: card_data[:description] },
      add_to_cart_button => { visible: true, enabled: true, caption: 'Add to Cart' }
    }
    verify_ui_states(ui)
    # verify the product rating
    within(self.get_locator) do
      verify_ui_states(checked_star => { count: card_data[:rating] })
    end
  end

  def card_action(action)
    case action.gsub(/\s+/, '_').downcase.to_sym
    when :double_click
      self.double_click
    when :right_click
      self.right_click
    when :click_at
      self.click_at(30, 50)
    else
      raise "#{action} is not a valid selector"
    end
  end
end
