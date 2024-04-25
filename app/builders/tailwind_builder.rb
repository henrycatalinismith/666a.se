class TailwindBuilder < ActionView::Helpers::FormBuilder
  # include ActionView::Helpers::TagHelper
  # include ActionView::Context
      # class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 #{'border-2 border-red-500' if @object.errors.any?}"

  def form(attribute, options={})
    super(attribute, options.reverse_merge(class: "flex flex-col gap-4 max-w-lg"))
  end

  def text_area(attribute, options={})
    super(attribute, options.reverse_merge(class: "border py-2 px-3 border py-2 px-3 block input border-gray-600 rounded-md shadow-sm focus:ring focus:ring-indigo-200 flex-1 w-full"))
  end

  def text_field(attribute, options={})
    super(attribute, options.reverse_merge(class: "block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 px-2"))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    super(method, choices, options, html_options.merge(class: "mt-2 block w-full rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6"), &block)
  end

  def email_field(attribute, options={})
    super(attribute, options.reverse_merge(class: "block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 px-2"))
  end

  def password_field(attribute, options={})
    super(attribute, options.reverse_merge(class: "block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 px-2"))
  end

  def label(attribute, options={})
    super(attribute, options.reverse_merge(class: "block text-sm font-medium leading-6 text-gray-900"))
  end

  def submit(attribute, options={})
    super(attribute, options.reverse_merge(class: "rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"))
    # bg-cyan-300 hover:bg-cyan-200 text-black font-bold
  end

  def check_box(attribute, options={})
    super(attribute, options.reverse_merge(class: "h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-60 ms-1"))
  end
end
