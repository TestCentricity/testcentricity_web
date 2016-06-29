require 'rubygems'
require 'dbi'
require 'oci8'
require 'ostruct'


module TestCentricity
  class DBQueryData < TestCentricity::ExcelDataSource

    WKS_DB_QUERIES ||= 'DB_Queries'

    def find_db_query(row_name)
      @current = DBQuery.new(read_excel_row_data(WKS_DB_QUERIES, row_name))
      DBQuery.set_current(@current)
    end
  end


  class DBQuery < TestCentricity::DataObject
    attr_accessor :query
    attr_accessor :result
    attr_accessor :attributes
    attr_accessor :type

    def initialize(data)
      @query = data['Query']
      super
    end

    def execute_query
      @result = []
      # establish connection to database
      dbh = DBI.connect("DBI:#{Environ.current.dns}", Environ.current.db_username, Environ.current.db_password)
      # load and execute the query
      rs = dbh.prepare(@query)
      rs.execute
      # return results as an array of hash
      rs.fetch_hash do |row|
        @result.push(row)
      end
      rs.finish
      dbh.disconnect
      # if any rows of data were returned, create and load the data object's attributes
      @attributes = OpenStruct.new(Hash[@result[0].map { |key, value| [key.downcase.to_sym, value] }]) if row_count > 0
    end

    def row_count
      @result.count
    end

    def row(row_num = 1)
      raise "Requested row #{row_num} exceeds number of rows (#{row_count}) returned by database query" if row_num > row_count
      @attributes = OpenStruct.new(Hash[@result[row_num - 1].map { |key, value| [key.downcase.to_sym, value] }])
      @attributes.to_h
    end
  end
end

