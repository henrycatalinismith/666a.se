class HomeQuoteComponentPreview < ViewComponent::Preview
  def home_quote
    render(HomeQuoteComponent.new())
  end
end
