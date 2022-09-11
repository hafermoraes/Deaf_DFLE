-- Abbreviated Life Tables
-- Brazilian Population Census 2010 (IBGE/Censo)
-- Source (accessed on September 7th, 2022):
--  ftp://ftp.ibge.gov.br/Tabuas_Abreviadas_de_Mortalidade/2010/tabelas_xls.zip

 select age_grp,   -- 5-year age
        gender,    -- both, male and female
        name,      -- life table functions
        value
   from censo2010.lifetables
  where name in ('lx', 'Lxn', 'Ex')
      ;