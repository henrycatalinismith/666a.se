require "test_helper"

class ResultTest < ActiveSupport::TestCase

  test "document_code" do
    result = Result.new(document_code: "abc")
    assert result.document_code == "abc"
  end

  test "document_date" do
    result = Result.new(document_date: "2023-05-05")
    assert result.document_date == "2023-05-05"
  end

  test "document_direction" do
    result = Result.new(metadata: {"Inkommande/Utgående": "Inkommande"}.to_json)
    assert result.document_direction == :incoming
    result = Result.new(metadata: {"Inkommande/Utgående": "Utgående"}.to_json)
    assert result.document_direction == :outgoing
  end

  test "document_type" do
    result = Result.new(document_type: "Asbest – anmälan om rivning av asbest 2023-10-16 - 2023-10-20, Bruksgatan 6, Sundsvall")
    assert result.document_type == "Asbest – anmälan om rivning av asbest 2023-10-16 - 2023-10-20, Bruksgatan 6, Sundsvall"
  end

  test "case_code" do
    result = Result.new(metadata: {"Diarienummer": "2023/058211"}.to_json)
    assert result.case_code == "2023/058211"
  end

  test "case_name" do
    result = Result.new(case_name: "abc")
    assert result.case_name == "abc"
  end

  test "case_status" do
    result = Result.new(metadata: {"Pågående/Avslutat": "Pågående"}.to_json)
    assert result.case_status == :ongoing
    result = Result.new(metadata: {"Pågående/Avslutat": "Avslutat"}.to_json)
    assert result.case_status == :concluded
  end

  test "company_code" do
    result = Result.new(metadata: {"Organisation": "AF HÄRNÖSAND BYGGRETURER AB (556538-8955)"}.to_json)
    assert result.company_code == "556538-8955"
    result = Result.new(metadata: {"Organisation": "Saknas"}.to_json)
    assert result.company_code == nil
  end

  test "company_name" do
    result = Result.new(metadata: {"Organisation": "AF HÄRNÖSAND BYGGRETURER AB (556538-8955)"}.to_json)
    assert result.company_name == "AF HÄRNÖSAND BYGGRETURER AB"
    result = Result.new(metadata: {"Organisation": "Saknas"}.to_json)
    assert result.company_name == nil
  end

  test "workplace_code" do
    result = Result.new(metadata: {"Arbetsställenummer (CFAR)": "30986400"}.to_json)
    assert result.workplace_code == "30986400"
    result = Result.new(metadata: {"Arbetsställenummer (CFAR)": "Saknas"}.to_json)
    assert result.workplace_code == nil
  end

  test "workplace_name" do
    result = Result.new(metadata: {"Arbetsställe": "REOMTI BYGG AB"}.to_json)
    assert result.workplace_name == "REOMTI BYGG AB"
    result = Result.new(metadata: {"Arbetsställe": "Saknas"}.to_json)
    assert result.workplace_name == nil
  end

  test "county_code" do
    result = Result.new(metadata: {"Län": "STOCKHOLMS LÄN (01)"}.to_json)
    assert result.county_code == "01"
    result = Result.new(metadata: {"Län": "Saknas"}.to_json)
    assert result.county_code == nil
  end

  test "county_name" do
    result = Result.new(metadata: {"Län": "STOCKHOLMS LÄN (01)"}.to_json)
    assert result.county_name == "STOCKHOLMS LÄN"
    result = Result.new(metadata: {"Län": "Saknas"}.to_json)
    assert result.county_name == nil
  end

  test "municipality_code" do
    result = Result.new(metadata: {"Kommun": "Stockholm (0180)"}.to_json)
    assert result.municipality_code == "0180"
    result = Result.new(metadata: {"Kommun": "Saknas"}.to_json)
    assert result.municipality_code == nil
  end

  test "municipality_name" do
    result = Result.new(metadata: {"Kommun": "Stockholm (0180)"}.to_json)
    assert result.municipality_name == "Stockholm"
    result = Result.new(metadata: {"Kommun": "Saknas"}.to_json)
    assert result.municipality_name == nil
  end
end
