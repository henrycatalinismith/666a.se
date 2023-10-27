class WorkEnvironment::Result < ApplicationRecord
  belongs_to :search

  enum metadata_status: {
    metadata_pending: 0,
    metadata_fetching: 1,
    metadata_ready: 2,
    metadata_error: 3,
    metadata_aborted: 4,
  }

  enum document_status: {
    document_pending: 0,
    document_active: 1,
    document_ready: 2,
    document_error: 3,
    document_aborted: 4,
  }

  def url
    host = "www.av.se"
    path = "/om-oss/sok-i-arbetsmiljoverkets-diarium/"
    query = { id: document_code }.to_query
    url = "https://#{host}#{path}?#{query}"
  end

  def document_direction
    direction = JSON.parse(metadata)["Inkommande/Utgående"]
    if direction == "Inkommande" then
      return :document_incoming
    elsif direction == "Utgående" then
      return :document_outgoing
    end
  end

  def case_code
    return JSON.parse(metadata)["Diarienummer"]
  end

  def case_date
    return JSON.parse(metadata)["Datum"]
  end

  def case_status
    status = JSON.parse(metadata)["Pågående/Avslutat"]
    if status == "Pågående" then
      return :case_ongoing
    elsif status == "Avslutat" then
      return :case_concluded
    end
  end

  def company_code
    organisation = JSON.parse(metadata)["Organisation"]
    if organisation.nil? or organisation == "Saknas" then
      return nil
    end
    matches = organisation.match(/(.+) \((\d{6}-\d{4})\)/)
    if matches.nil? then
      return nil
    end
    return matches[2]
  end

  def company_name
    organisation = JSON.parse(metadata)["Organisation"]
    if organisation.nil? or organisation == "Saknas" then
      return nil
    end
    matches = organisation.match(/(.+) \((\d{6}-\d{4})\)/)
    if matches.nil? then
      return nil
    end
    return matches[1]
  end

  def workplace_code
    cfar = JSON.parse(metadata)["Arbetsställenummer (CFAR)"]
    if cfar.nil? or cfar == "Saknas" then
      return nil
    end
    return cfar
  end

  def workplace_name
    name = JSON.parse(metadata)["Arbetsställe"]
    if name.nil? or name == "Saknas" then
      return nil
    end
    return name
  end

  def county_code
    county = JSON.parse(metadata)["Län"]
    if county.nil? or county == "Saknas" then
      return nil
    end
    matches = county.match(/(.+) \((\d+)\)/)
    if matches.nil? then
      return nil
    end
    return matches[2]
  end

  def county_name
    county = JSON.parse(metadata)["Län"]
    if county.nil? or county == "Saknas" then
      return nil
    end
    matches = county.match(/(.+) \((\d+)\)/)
    if matches.nil? then
      return nil
    end
    return matches[1]
  end

  def municipality_code
    municipality = JSON.parse(metadata)["Kommun"]
    if municipality.nil? or municipality == "Saknas" then
      return nil
    end
    matches = municipality.match(/(.+) \((\d+)\)/)
    if matches.nil? then
      return nil
    end
    return matches[2]
  end

  def municipality_name
    municipality = JSON.parse(metadata)["Kommun"]
    if municipality.nil? or municipality == "Saknas" then
      return nil
    end
    matches = municipality.match(/(.+) \((\d+)\)/)
    if matches.nil? then
      return nil
    end
    return matches[1]
  end

  def to_document
    WorkEnvironment::Document.new(
      document_code: document_code,
      document_date: document_date,
      document_direction: document_direction,
      document_type: document_type,
      case_code: case_code,
      case_date: case_date,
      case_name: case_name,
      case_status: case_status,
      company_code: company_code,
      company_name: company_name,
      workplace_code: workplace_code,
      workplace_name: workplace_name,
      county_code: county_code,
      county_name: county_name,
      municipality_code: municipality_code,
      municipality_name: municipality_name,
    )
  end
end