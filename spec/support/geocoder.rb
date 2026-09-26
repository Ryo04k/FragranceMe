# テスト中に Google Geocoding API へ実リクエストを送らないようにする
Geocoder.configure(lookup: :test, ip_lookup: :test)
Geocoder::Lookup::Test.set_default_stub([])
