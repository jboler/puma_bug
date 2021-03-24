require 'csv'

class ApplicationController < ActionController::Base
  BYTE_ORDER_MARK = "\377\376".force_encoding(Encoding::UTF_16LE)
  CSV_OPTIONS = { col_sep: "\t", force_quotes: false }.freeze

  def root
    headers['Content-Type'] = 'text/csv; charset=utf-16le'
    headers['Content-Disposition'] = 'attachment; filename="file.csv"'

    csv_body = Enumerator.new do |yielder|
      yielder << BYTE_ORDER_MARK
      ['A,B,C', '1,2,3'].each do |entry|
        yielder << CSV.generate_line(entry.split(','), CSV_OPTIONS).encode(Encoding::UTF_16LE)
      end
    end

    self.response_body = csv_body
  end
end
