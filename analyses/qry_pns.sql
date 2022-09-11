-- National Health Survey (PNS/IBGE)
-- Questionnaire (accessed on September 7th, 2022): 
--   https://www.pns.icict.fiocruz.br/wp-content/uploads/2021/02/Questionario-PNS-2019.pdf

 select -- survey design variables
        upa_pns, v0024, 
        v0028, v00281, v00282, v00283,    -- chosen respondent answers in the name of all persons of household
        -- v0029, v00291, v00292, v00293, -- answers from chosen respondent only
        -- v0030, v00301, v00302, v00303, -- answers from anthropometric questionaire
        -- variables for analyses
        j001,   -- health_perception (for validation purposes only...)
        c006,   -- gender
        c008,   -- age
        q092,   -- ever diagnosed with depression by a physician
        q11006, -- ever diagnosed with anxiety by a physician
        g058,   -- hearing impairment level
        g057,   -- hearing impairment level even using hearning devices
        g05801  -- knowdledge of Libras, the brazilian sign language
   from pns2019.microdata 
  where v0028 ~ '\d+' -- (weight variable) v0028 not empty
    and v0015 = '01'  -- only effective and successful interviews
      ;