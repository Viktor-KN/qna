module FilesTestHelpers
  extend self
  extend ActionDispatch::TestProcess

  def png_name
    'test.png'
  end

  def txt_name
    'test.txt'
  end

  def zip_name
    'test.zip'
  end

  def png
    upload(png_name, 'image/png')
  end

  def txt
    upload(txt_name, 'text/plain')
  end

  def zip
    upload(zip_name, 'application/zip')
  end

  def test_assets_path(name)
    Rails.root.join('spec', 'support', 'assets', name)
  end

  private

  def upload(name, type)
    file_path = test_assets_path(name)
    fixture_file_upload(file_path, type)
  end
end
