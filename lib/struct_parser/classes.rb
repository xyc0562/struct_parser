module StructParser::Classes
  Operation = StructParser::Operation
  MapParser = StructParser::Parsers::MapParser
  PhoneNoParser = StructParser::Parsers::PhoneNoParser
  FreeTextParser = StructParser::Parsers::FreeTextParser
  Category = StructParser::Container::Category
  Sheet = StructParser::Container::Sheet
  Row = StructParser::Container::Row
  Column = StructParser::Container::Column
  Cell = StructParser::Container::Cell
  IUtils = StructParser::Utils
  And = StructParser::And

  ColumnAssignOperation = StructParser::Operation::ColumnAssignOperation
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