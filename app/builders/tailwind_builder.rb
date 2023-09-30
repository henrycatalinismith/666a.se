class TailwindBuilder < ActionView::Helpers::FormBuilder
  # include ActionView::Helpers::TagHelper
  # include ActionView::Context
      # class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 #{'border-2 border-red-500' if @object.errors.any?}"

  def form(attribute, options={})
    super(attribute, options.reverse_merge(class: "flex flex-col gap-4 max-w-lg"))
  end

  def text_field(attribute, options={})
    super(attribute, options.reverse_merge(class: "block input border-gray-600 rounded-md shadow-sm focus:ring focus:ring-indigo-200 flex-1"))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    super(method, choices, options, html_options.merge(class: "block input border-gray-600 rounded-md shadow-sm focus:ring focus:ring-indigo-200 f min-w-full"), &block)
  end

  def email_field(attribute, options={})
    super(attribute, options.reverse_merge(class: "block input border-gray-600 rounded-md shadow-sm focus:ring focus:ring-indigo-200"))
  end

  def password_field(attribute, options={})
    super(attribute, options.reverse_merge(class: "block input border-gray-600 rounded-md shadow-sm focus:ring focus:ring-indigo-200"))
  end

  def label(attribute, options={})
    super(attribute, options.reverse_merge(class: ""))
  end

  def submit(attribute, options={})
    super(attribute, options.reverse_merge(class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"))
  end

end