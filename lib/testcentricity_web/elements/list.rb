module TestCentricity
  class List < UIElement
    attr_accessor :list_item

    def initialize(name, parent, locator, context)
      super
      @type = :list
      define_list_elements({ :list_item => 'li' })
    end

    def define_list_elements(element_spec)
      element_spec.each do |element, value|
        case element
        when :list_item
          @list_item = value
        else
          raise "#{element} is not a recognized list element"
        end
      end
    end

    def get_list_items(element_spec = nil)
      define_list_elements(element_spec) unless element_spec.nil?
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item).collect(&:text)
    end

    def get_list_item(index, visible = true)
      if visible
        items = get_list_items
      else
        items = get_all_list_items
      end
      items[index - 1]
    end

    def get_item_count
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item).count
    end

    def get_all_list_items(element_spec = nil)
      define_list_elements(element_spec) unless element_spec.nil?
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item, :visible => :all).collect(&:text)
    end

    def get_all_items_count
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item, :visible => :all).count
    end

    def verify_list_items(expected, enqueue = false)
      actual = get_list_items
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list #{object_ref_message}") :
          assert_equal(expected, actual, "Expected list #{object_ref_message} to be #{expected} but found #{actual}")
    end

    def get_list_row_locator(row)
      case @locator_type
      when :xpath
        "#{@locator}/#{@list_item}[#{row}]"
      when :css
        "#{@locator} > #{@list_item}:nth-of-type(#{row})"
      end
    end
  end
end
