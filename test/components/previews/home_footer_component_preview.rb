class HomeFooterComponentPreview < ViewComponent::Preview
  def home_footer
    render(HomeFooterComponent.new())
  end
end
