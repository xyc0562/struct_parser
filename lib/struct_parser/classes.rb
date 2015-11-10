module StructParser
  module Classes
    Operation = StructParser::Operation
    MapParser = StructParser::Parsers::MapParser
    PhoneNoParser = StructParser::Parsers::PhoneNoParser
    FreeTextParser = StructParser::Parsers::FreeTextParser
    Category = StructParser::Containers::Category
    Sheet = StructParser::Containers::Sheet
    Row = StructParser::Containers::Row
    Column = StructParser::Containers::Column
    Cell = StructParser::Containers::Cell
    IUtils = StructParser::Utils
    And = StructParser::And

    ColumnAssignOperation = StructParser::Operations::ColumnAssignOperation
    AddressParser = StructParser::Parsers::AddressParser
    CurrencyParser = StructParser::Parsers::CurrencyParser
    UpcaseParser = StructParser::Parsers::UpcaseParser
    DbIdOperation = StructParser::Operations::DbIdOperation
    DbIdParser = StructParser::Parsers::DbIdParser
    RowInsertOperation = StructParser::Operations::RowInsertOperation
    RowAssignOperation = StructParser::Operations::RowAssignOperation
    EmailParser = StructParser::Parsers::EmailParser
    HeaderGuard = StructParser::Guards::HeaderGuard
  end
end
