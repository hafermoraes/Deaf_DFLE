#!/bin/bash

# variaveis
awk '$1 ~ /^[^"\n\r]/' /tmp/paa_pns/pg_pns2019_vars > /tmp/paa_pns/aux 
mv /tmp/paa_pns/aux /tmp/paa_pns/pg_pns2019_vars

sed 's/"//g' -i /tmp/paa_pns/pg_pns2019_vars

# microdados
ARG_C=$(cat /tmp/paa_pns/arg_cut)
cut --output-delimiter='|' -c$ARG_C /tmp/paa_pns/PNS_2019.txt > /tmp/paa_pns/pg_pns2019_microdata.csv

# Dicionário de dados da PNS 2019:

# V0001       1-2       (2)   Unidade da Federação
# V0024       3-9       (7)   Estrato
# UPA_PNS     10-18     (9)   UPA
# V0006_PNS   19-22     (4)   Número de ordem do domicílio na PNS
# V0015       23-24     (2)   Tipo da entrevista
# V0020       25-28     (4)   Ano de referência
# V0022       29-30     (2)   Total de moradores
# V0026       31-31     (1)   Tipo de situação censitária
# V0031       32-32     (1)   Tipo de área
# V0025A      33-33     (1)   Seleção do morador de 15 anos ou mais para responder o questionário individual
# V0025B      34-34     (1)   Seleção do morador de 15 anos ou mais para ter medida antropométrica aferida
# A001        35-35     (1)   Tipo do domicílio
# A002010     36-36     (1)   Qual é o material que predomina na construção das paredes externas deste domicílio?
# A003010     37-37     (1)   Material predominante na cobertura (telhado) do domicílio
# A004010     38-38     (1)   Qual é o material que predomina no piso deste domicílio
# A01001      39-40     (2)   Quantos cômodos têm este domicílio
# A011        41-42     (2)   Quantos cômodos estão servindo permanentemente de dormitório para os moradores deste domicílio
# A005010     43-43     (1)   Qual é a principal forma de abastecimento de água deste domicílio
# A005012     44-44     (1)   Este domicílio está ligado à rede geral de distribuição de água?
# A00601      45-45     (1)   A água utilizada neste domicílio chega
# A009010     46-46     (1)   A água utilizada para beber neste domicílio é
# A01401      47-48     (2)   Quantos banheiros (com chuveiro ou banheira e vaso sanitário ou privada) de uso exclusivo dos moradores existem neste domicílio, inclusive os localizados no terreno ou propriedade
# A01402      49-50     (2)   Quantos banheiros (com chuveiro ou banheira e vaso sanitário ou privada) de uso comum a mais de um domicilio, existem neste terreno ou propriedade
# A01403      51-51     (1)   Utiliza sanitário ou buraco para dejeções, inclusive os localizados no terreno ou na propriedade (cercado por paredes de qualquer material
# A01501      52-52     (1)   Para onde vai o esgoto do banheiro? Ou Para onde vai o esgoto do sanitário ou do buraco para dejeções?
# A016010     53-53     (1)   Qual o (principal) destino dado ao lixo
# A018011     54-54     (1)   Neste domicílio existe televisão em cores
# A018012     55-56     (2)   Quantos?
# A018013     57-57     (1)   Neste domicílio existe geladeira
# A018014     58-59     (2)   Quantos?
# A018015     60-60     (1)   Neste domicílio existe máquina de lavar roupa
# A018016     61-62     (2)   Quantos?
# A018017     63-63     (1)   Neste domicílio existe telefone fixo convencional
# A018018     64-65     (2)   Quantos?
# A018019     66-66     (1)   Neste domicílio existe telefone móvel celular
# A018020     67-68     (2)   Quantos?
# A018021     69-69     (1)   Neste domicílio existe forno micro-ondas
# A018022     70-71     (2)   Quantos?
# A018023     72-72     (1)   Neste domicílio existe computador (considere inclusive os portáteis, tais como: laptop, notebook ou netbook)?
# A018024     73-74     (2)   Quantos?
# A018025     75-75     (1)   Neste domicílio existe motocicleta
# A018026     76-77     (2)   Quantos?
# A018027     78-78     (1)   Neste domicílio existe automóvel
# A018028     79-80     (2)   Quantos?
# A01901      81-81     (1)   Algum morador tem acesso à Internet no domicílio por meio de computador, tablet, telefone móvel celular, televisão ou outro equipamento?
# A02101      82-82     (1)   No seu domicílio, há trabalhador (as) doméstico(as) que trabalham em seu domicílio três vezes ou mais por semana (empregada doméstica, babá, cuidador etc.)
# A02102      83-84     (2)   Quantos?
# A02201      85-85     (1)   Em seu domicílio, há algum animal de estimação
# A02305      86-87     (2)   Quantos destes animais são gatos
# A02306      88-89     (2)   Quantos destes animais são cachorros
# A02307      90-91     (2)   Quantos destes animais são aves
# A02308      92-93     (2)   Quantos destes animais são peixes
# A02401      94-95     (2)   Nos últimos 12 meses, quantos gatos foram vacinados contra raiva?
# A02402      96-97     (2)   Nos últimos 12 meses , quantos cachorros foram vacinados contra raiva?
# B001        98-98     (1)   O seu domicílio está cadastrado na unidade de saúde da família
# B002        99-99     (1)   . Quando o seu domicílio foi cadastrado
# B003        100-100   (1)   Nos últimos doze meses, com que frequência o seu domicílio recebeu uma visita de algum Agente Comunitário ou algum membro da Equipe de Saúde da Família?
# B004        101-101   (1)   Nos últimos doze meses, com que frequência o seu domicílio recebeu uma visita de algum agente de endemias (como a dengue, por exemplo)
# C001        102-103   (2)   Número de pessoas no domicílio
# C00301      104-105   (2)   Número de ordem do morador
# C004        106-107   (2)   Condição no domicílio
# C006        108-108   (1)   Sexo
# C00701      109-110   (2)   Dia de nascimento
# C00702      111-112   (2)   Mês de nascimento
# C00703      113-116   (4)   Ano de nascimento
# C008        117-119   (3)   Idade do morador na data de referência
# C009        120-120   (1)   Cor ou raça
# C01001      121-121   (1)   Cônjuge ou companheiro(a) mora em nesse domicílio.
# C010010     122-123   (2)   Número de ordem do cônjuge ou companheiro(a)
# C013        124-124   (1)   Cônjuge ou companheiro(a) mora em outro domicílio.
# C014        125-125   (1)   Qual é a natureza dessa união?
# C015        126-126   (1)   Esta união é registrada em cartório?
# C016        127-127   (1)   Foi realizada cerimônia religiosa para esta união?
# C017        128-128   (1)   ___já viveu com cônjuge ou companheiro (a) antes?
# C018        129-129   (1)   Que idade ___tinha quando começou a viver com seu(sua) primeiro(a)/único(a) marido (mulher) ou companheiro(a)?
# C01801      130-132   (3)   Que idade ___tinha quando começou a viver com seu(sua) primeiro(a)/único(a) marido (mulher) ou companheiro(a)?
# C011        133-133   (1)   Qual é o estado civil de ___?
# C012        134-134   (1)   Informante do Módulo C
# D001        135-135   (1)   Sabe ler e escrever
# D00201      136-136   (1)   Frequenta escola ou creche
# D00202      137-137   (1)   A escola que frequenta é da
# D00301      138-139   (2)   Qual é o curso que frequenta
# D00501      140-140   (1)   Esse curso que ___ frequenta é dividido em
# D006        141-142   (2)   Qual é o ano/semestre/série que ___frequenta?
# D00601      143-143   (1)   NA
# D007        144-144   (1)   ___já concluiu algum outro curso superior de graduação
# D008        145-145   (1)   Anteriormente ___frequentou escola ou creche
# D00901      146-147   (2)   Qual foi o curso mais elevado que ___frequentou
# D010        148-148   (1)   A duração deste curso que ___frequentou anteriormente era de
# D01101      149-149   (1)   Este curso que ___ frequentou anteriormente era dividido em
# D01201      150-150   (1)   concluiu, com aprovação, pelo menos o primeiro ano/semestre/série deste curso que frequentou
# D01301      151-152   (2)   Qual foi o último ano/semestre/série que ___ concluiu, com aprovação, neste curso que frequentou
# D01302      153-153   (1)   Qual foi a etapa de ensino fundamental que ___frequentou
# D01303      154-154   (1)   ___concluiu os anos iniciais deste curso que frequentou
# D014        155-155   (1)   ___concluiu este curso que frequentou
# D015        156-157   (2)   Informante do Módulo D
# E001        158-158   (1)   Na semana de___ a___ (semana de referência), ___ trabalhou ou estagiou, durante pelo menos uma hora, em alguma atividade remunerada em dinheiro
# E002        159-159   (1)   Na semana de ___a___ (semana de referência), ___ trabalhou ou estagiou, durante pelo menos uma hora, em alguma atividade remunerada em produtos, mercadorias, moradia, alimentação, treinamento ou aprendizado etc
# E003        160-160   (1)   Na semana de ___ a ___ (semana de referência), ___ fez algum bico ou trabalhou em alguma atividade ocasional remunerada durante pelo menos 1 hora
# E004        161-161   (1)   Na semana de ___ a ___ (semana de referência), ___ ajudou durante pelo menos 1 hora, sem receber pagamento, no trabalho remunerado de algum morador do domicílio ou de parente
# E005        162-162   (1)   Na semana de ___ a ___ (semana de referência), ___ tinha algum trabalho remunerado do qual estava temporariamente afastado
# E006011     163-163   (1)   Na semana de ___ a ___ (semana de referência), por que motivo ___ estava afastado desse trabalho
# E008        164-164   (1)   A doença ou acidente foi relacionado ao trabalho?
# E010010     165-165   (1)   Em ___ /___ /___ (último dia da semana de referência), fazia quanto tempo que ___ estava afastado desse trabalho
# E010011     166-167   (2)   Tempo que estava afastado (De 1 mês a menos de 1 ano)
# E010012     168-169   (2)   Tempo que estava afastado (De 1 ano a menos de 2 anos)
# E010013     170-171   (2)   Tempo que estava afastado (De 2 anos a 98 anos)
# E011        172-172   (1)   Quantos trabalhos ___tinha na semana de ___ a ___
# E01201      173-176   (4)   Qual era a ocupação (cargo ou função) que ___ tinha nesse trabalho
# E01401      177-177   (1)   Nesse trabalho, ___ era
# E014011     178-178   (1)   Trabalhador não remunerado em ajuda a membro do domicílio ou parente
# E01402      179-179   (1)   Nesse trabalho, ___era servidor público estatutário (federal, estadual ou municipal)
# E01403      180-180   (1)   Nesse trabalho, ___tinha carteira de trabalho assinada
# E01501      181-185   (5)   Qual era a principal atividade desse negócio/empresa
# E01601      186-186   (1)   ...recebia/fazia normalmente nesse trabalho rendimento/retirada em dinheiro?
# E01602      187-194   (8)   Qual era o rendimento bruto mensal ou retirada que ___ fazia normalmente nesse trabalho?(valor em dinheiro)
# E01603      195-195   (1)   ...recebia/fazia normalmente nesse trabalho rendimento/retirada em produtos ou mercadorias?
# E01604      196-203   (8)   Qual era o rendimento bruto mensal ou retirada que ___ fazia normalmente nesse trabalho?(valor estimado em produtos ou mercadorias)
# E01605      204-204   (1)   ...recebia/fazia normalmente nesse trabalho rendimento/retirada somente em benefícios ?
# E017        205-207   (3)   Quantas horas ___ trabalhava normalmente, por semana, nesse trabalho?
# E01801      208-208   (1)   ...recebia/fazia normalmente nesse(s) outro(s) trabalho(s) rendimento/retirada em dinheiro?
# E01802      209-216   (8)   Qual era o rendimento bruto mensal ou retirada que ___ fazia normalmente nesse(s) outro(s) trabalho(s)?(valor em dinheiro)
# E01803      217-217   (1)   ...recebia/fazia normalmente nesse(s) outro(s) trabalho(s) rendimento/retirada em produtos ou mercadorias?
# E01804      218-225   (8)   Qual era o rendimento bruto mensal ou retirada que ___ fazia normalmente nesse(s) outro(s) trabalho(s)?(valor estimado em produtos ou mercadorias)
# E01805      226-226   (1)   ...recebia/fazia normalmente nesse(s) outro(s) trabalho(s) rendimento/retirada somente em benefícios ?
# E019        227-229   (3)   Quantas horas ___ trabalhava normalmente, por semana, nesses outros trabalhos?
# E022        230-230   (1)   No período de ___ a ___ (período de referência de 30 dias), ___ tomou alguma providência para conseguir trabalho, seja um emprego ou um negócio próprio?
# E023011     231-232   (2)   No período de ___ a ___ (período de referência de 30 dias), qual foi a principal providência que ___ tomou para conseguir trabalho?
# E024011     233-234   (2)   Qual foi o principal motivo de ___ não ter tomado providência para conseguir trabalho no período de ___ a ___ (período de referência de 30 dias)?
# E02402      235-235   (1)   Quanto tempo depois de __/__/__ (último dia da semana de referência) ___ irá começar esse trabalho que conseguiu?
# E024021     236-237   (2)   Número de meses para começar o trabalho que conseguiu.
# E025        238-238   (1)   Até o dia ___ (último dia da semana de referência), fazia quanto tempo que___ estava sem qualquer trabalho e tentando conseguir trabalho?
# E02501      239-240   (2)   fazia quanto tempo que vinha procurando trabalho (de 1 mês a menos de 1 ano)
# E02502      241-242   (2)   fazia quanto tempo que vinha procurando trabalho (de 1 ano a menos de 2 anos)
# E02503      243-244   (2)   fazia quanto tempo vinha procurando trabalho (2 anos ou mais)
# E026        245-245   (1)   Se tivesse conseguido um trabalho ___ poderia ter começado a trabalhar na semana de___ a ___ (semana de referência)
# E02601      246-246   (1)   No período de ___ a ___ (período de referência de 358 dias), ___ trabalhou, por pelo menos 1 hora?
# E02801      247-247   (1)   Na semana de ___a___ (semana de referência), ___ realizou tarefas de cuidados de moradores deste domicílio que eram crianças, idosos, enfermos ou pessoas com necessidades especiais, tais como: Auxiliar nos cuidados pessoais (alimentar, vestir, pentear, dar remédio, dar banho, colocar para dormir)
# E02802      248-248   (1)   Na semana de ___a___ (semana de referência), ___ realizou tarefas de cuidados de moradores deste domicílio que eram crianças, idosos, enfermos ou pessoas com necessidades especiais, tais como: Auxiliar em atividades educacionais
# E02803      249-249   (1)   Na semana de ___a___ (semana de referência), ___ realizou tarefas de cuidados de moradores deste domicílio que eram crianças, idosos, enfermos ou pessoas com necessidades especiais, tais como: Ler, jogar ou brincar
# E02804      250-250   (1)   Na semana de ___a___ (semana de referência), ___ realizou tarefas de cuidados de moradores deste domicílio que eram crianças, idosos, enfermos ou pessoas com necessidades especiais, tais como: Monitorar ou fazer companhia dentro do domicílio
# E02805      251-251   (1)   Na semana de ___a___ (semana de referência), ___ realizou tarefas de cuidados de moradores deste domicílio que eram crianças, idosos, enfermos ou pessoas com necessidades especiais, tais como: Transportar ou acompanhar para escola, médico, exames, parque, praça, atividades sociais, culturais, esportivas ou religiosas
# E02806      252-252   (1)   Outras tarefas de cuidados de moradores do domicílio
# E030        253-253   (1)   Na semana de ___ a ___ (semana de referência), ___ cuidou de parentes que não moravam neste domicílio e que precisavam de cuidados (crianças, idosos, enfermos ou pessoas com necessidades especiais)?
# E03101      254-254   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: preparar ou servir alimentos, arrumar a mesa ou lavar as louças?
# E03102      255-255   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: cuidar da limpeza ou manutenção de roupas e sapatos/
# E03103      256-256   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: fazer pequenos reparos ou manutenção do domicílio, do automóvel, de eletrodomésticos ou outros equipamentos?
# E03104      257-257   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: Limpar ou arrumar o domicílio, a garagem, o quintal ou o jardim?
# E03105      258-258   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: Cuidar da organização do domicílio (pagar contas, contratar serviços, orientar empregados etc.)?
# E03106      259-259   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: Fazer compras ou pesquisar preços de bens para o domicílio?
# E03107      260-260   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: Cuidar dos animais domésticos?
# E03108      261-261   (1)   Na semana de___a___ (semana de referência), ___fez tarefas domésticas para o próprio domicílio, tais como: Outras tarefas domésticas?
# E032        262-262   (1)   . Na semana de___a___ (semana de referência), ___fez alguma tarefa doméstica em domicílio de parente?
# E033        263-265   (3)   . Na semana de___a___ (semana de referência), ___ qual foi o total de horas que dedicou às atividades de cuidados de pessoas e/ou afazeres domésticos?
# E027        266-266   (1)   Informante do Módulo E
# F001011     267-267   (1)   Em (mês da pesquisa) ___ recebia normalmente rendimento de aposentadoria ou pensão de instituto de previdência federal (INSS), estadual, municipal, ou do governo federal, estadual, municipal?
# F001021     268-275   (8)   Valor habitualmente recebido
# F007011     276-276   (1)   Em (mês da pesquisa), ___ recebia normalmente rendimento de pensão alimentícia, doação ou mesada em dinheiro de pessoa que não morava no domicílio?
# F007021     277-284   (8)   Valor habitualmente recebido
# F008011     285-285   (1)   Em (mês da pesquisa), ___ recebia normalmente rendimento de aluguel ou arrendamento?
# F008021     286-293   (8)   Valor habitualmente recebido
# VDF001      294-294   (1)   Em (mês da pesquisa), _______ recebia normalmente algum juro de caderneta de poupança e de outras aplicações financeiras, dividendos, programas sociais, seguro-desemprego, seguro defeso ou outros rendimentos?
# VDF00102    295-302   (8)   Valor recebido em reais (VDF001)
# F016        303-303   (1)   Informante do Módulo F
# G033        304-304   (1)   . ___ usa óculos ou outro aparelho de auxílio para lidar com problemas de visão?
# G034        305-305   (1)   ____________ faz uso de óculos?
# G035        306-306   (1)   Os óculos foram obtidos no SUS?
# G036        307-307   (1)   ____________ faz uso de lentes de contato?
# G038        308-308   (1)   ____________ faz uso de lupas ou lentes especiais?
# G039        309-309   (1)   As lupas ou lentes especiais foram obtidos no SUS?
# G040        310-310   (1)   ____________ faz uso de bengala articulada?
# G041        311-311   (1)   A bengala articulada foi obtida no SUS?
# G042        312-312   (1)   ____________ faz uso de cão guia?
# G044        313-313   (1)   ____________ faz uso de algum outro aparelho de auxílio para lidar com problemas de visão?
# G046        314-314   (1)   . ___ tem dificuldade permanente de enxergar mesmo usando óculos, lentes de contato ou lupas?
# G047        315-315   (1)   ___ tem dificuldade permanente de enxergar?
# G048        316-316   (1)   ___ usa aparelho auditivo ou outro aparelho de auxílio para ouvir melhor?
# G049        317-317   (1)   ____________ faz uso de aparelho auditivo
# G050        318-318   (1)   O aparelho auditivo foi obtido no SUS?
# G051        319-319   (1)   ____________ faz uso de implante coclear?
# G052        320-320   (1)   O implante coclear foi obtido no SUS?
# G053        321-321   (1)   ____________ faz uso de sistema de frequência modulada individual (sistema FM)?
# G054        322-322   (1)   O sistema de frequência modulada individual (sistema FM) foi obtido no SUS?
# G055        323-323   (1)   ____________ faz uso de algum outro aparelho de auxílio para ouvir melhor?
# G057        324-324   (1)   ___ tem dificuldade permanente de ouvir mesmo usando aparelhos auditivos? (Para moradores com 5 anos ou mais de idade.) OU ___ tem dificuldade permanente para ouvir sons como vozes ou música, mesmo usando aparelhos auditivos? (Para moradores com 2 a 4 anos de idade.)
# G058        325-325   (1)   ___ tem dificuldade permanente de ouvir? (Para moradores com 5 anos ou mais de idade.)OU___ tem dificuldade permanente de ouvir sons como vozes ou música? (Para moradores com 2 a 4 anos de idade.)
# G05801      326-326   (1)   Sabe usar a Língua Brasileira de Sinais – Libras? (Para moradores com 5 anos ou mais de idade.)
# G059        327-327   (1)   ___ usa algum aparelho de auxílio para se locomover?
# G060        328-328   (1)   ____________ faz uso de cadeira de rodas?
# G061        329-329   (1)   A cadeira de rodas foi obtida no SUS?
# G062        330-330   (1)   ____________ faz uso de bengala, muletas ou andador?
# G063        331-331   (1)   A bengala, muletas ou andador foram obtidas no SUS?
# G064        332-332   (1)   ____________ faz uso de prótese?
# G065        333-333   (1)   A prótese foi obtida no SUS?
# G066        334-334   (1)   ____________ faz uso de órtese?
# G067        335-335   (1)   A órtese foi obtida no SUS?
# G068        336-336   (1)   ____________ faz uso de algum outro aparelho de auxílio para se locomover?
# G070        337-337   (1)   ___ tem dificuldade permanente de caminhar ou subir degraus, mesmo usando prótese, bengala ou outro aparelho de auxílio? (Para moradores com 5 anos ou mais de idade.)OUComparado com crianças da mesma idade, ___ tem dificuldade permanente para caminhar, mesmo usando prótese, bengala ou aparelho de auxílio? (Para moradores com 2 a 4 anos de idade.)
# G071        338-338   (1)   ___ tem dificuldade permanente de caminhar ou subir degraus? (Para moradores com 5 anos ou mais de idade.)OUComparado com crianças da mesma idade, ___ tem dificuldade permanente para caminhar? (Para moradores com 2 a 4 anos de idade.)
# G072        339-339   (1)   ___ usa algum aparelho de auxílio para realizar movimentos com os membros superiores?
# G073        340-340   (1)   ____________ faz uso de prótese para os membros superiores?
# G074        341-341   (1)   A prótese para os membros superiores foi obtida no SUS?
# G075        342-342   (1)   ____________ faz uso de órtese para os membros superiores?
# G076        343-343   (1)   A órtese para os membros superiores foi obtida no SUS?
# G077        344-344   (1)   ____________ faz uso de algum outro aparelho de auxílio para realizar movimentos com os membros superiores?
# G079        345-345   (1)   ___tem dificuldade permanente para levantar uma garrafa com dois litros de água da cintura até a altura dos olhos, mesmo usando prótese ou aparelho de auxílio? (Somente para moradores com 5 anos ou mais de idade.)
# G080        346-346   (1)   ___ tem dificuldade permanente para pegar objetos pequenos, como botões e lápis, ou abrir e fechar recipientes ou garrafas, mesmo usando prótese ou aparelho de auxílio? (Somente para moradores com 5 anos ou mais de idade.)OUComparado com crianças da mesma idade, ___ tem dificuldade permanente para pegar objetos pequenos, mesmo usando prótese ou aparelho de auxílio? (Para moradores com 2 a 4 anos de idade.)
# G081        347-347   (1)   ___ tem dificuldade permanente para levantar uma garrafa com dois litros de água da cintura até a altura dos olhos? (Somente para moradores com 5 anos ou mais de idade.)
# G082        348-348   (1)   ___ tem dificuldade permanente para pegar objetos pequenos, como botões e lápis, ou abrir e fechar recipientes ou garrafas? (Somente para moradores com 5 anos ou mais de idade.)OUComparado com crianças da mesma idade, ___ tem dificuldade permanente para pegar objetos pequenos? (Para moradores com 2 a 4 anos de idade.)
# G083        349-349   (1)   Por causa de alguma limitação nas funções mentais ou intelectuais, _________ tem dificuldade permanente para realizar atividades habituais, como se comunicar, realizar cuidados pessoais, trabalhar, ir à escola, brincar, etc.? (Para moradores com 5 anos ou mais de idade.)OUPor causa de alguma limitação nas funções mentais ou intelectuais, _________ tem dificuldade permanente para realizar atividades habituais, como frequentar a escola, brincar e etc.? (Para moradores com 2 a 4 anos de idade.)
# G084        350-350   (1)   Nos últimos doze meses ___ recebe ou recebeu, algum cuidado em reabilitação de forma regular? (Por reabilitação quero dizer fisioterapia, terapia ocupacional, fonoaudiologia psicoterapia etc.)
# G085        351-351   (1)   Onde você recebe (recebeu) esse cuidado em reabilitação?
# G086        352-352   (1)   Como você conseguiu ter acesso a esse cuidado em reabilitação?
# G032        353-353   (1)   Informante do Módulo G
# I00101      354-354   (1)   tem algum plano odontológico particular, de empresa ou órgão público?
# I00102      355-355   (1)   tem algum plano de saúde médico particular, de empresa ou órgão público?
# I001021     356-357   (2)   Quantos?
# I00103      358-358   (1)   Quem é o titular do plano de saúde médico (único ou principal)?
# I001031     359-360   (2)   Nº de ordem do titular
# I005        361-361   (1)   Há quanto tempo sem interrupção _____ possui esse plano de saúde (único ou principal)?
# I006        362-362   (1)   ___ considera este plano de saúde:
# I004        363-363   (1)   O plano de saúde médico (único ou principal) que _____ possui é de instituição de assistência de servidor público (municipal, estadual ou militar)?
# I00401      364-364   (1)   O plano de saúde (único ou principal) de assistência médica que ___ possui dá direito a consultas
# I00402      365-365   (1)   O plano de saúde (único ou principal) de assistência médica que ___ possui dá direito a exames
# I00403      366-366   (1)   O plano de saúde (único ou principal) de assistência médica que ___ possui dá direito a internações
# I00404      367-367   (1)   O plano de saúde (único ou principal) de assistência médica que ___ possui dá direito a partos
# I010010     368-368   (1)   Quem paga a mensalidade deste plano de saúde?
# I012        369-369   (1)   Informante do Módulo I
# J001        370-370   (1)   De um modo geral, como é o estado de saúde de________
# J00101      371-371   (1)   Considerando saúde como um estado de bem-estar físico e mental, e não somente a ausência de doenças, como é o estado de saúde de _____________?
# J002        372-372   (1)   Nas duas últimas semanas, ___ deixou de realizar quaisquer de suas atividades habituais (trabalhar, ir à escola, brincar, afazeres domésticos etc.) por motivo da própria saúde
# J003        373-374   (2)   Nas duas últimas semanas, quantos dias _____ deixou de realizar suas atividades habituais, por motivo da própria saúde
# J00402      375-376   (2)   Qual foi o principal motivo de saúde que impediu ___ de realizar suas atividades habituais nas duas últimas semanas
# J00404      377-377   (1)   Este motivo de saúde estava relacionado ao trabalho
# J005        378-378   (1)   Nas duas últimas semanas___ esteve acamado (a)
# J006        379-380   (2)   Nas duas últimas semanas, quantos dias _____ esteve acamado (a)
# J007        381-381   (1)   Algum médico já deu o diagnóstico de alguma doença crônica, física ou mental, ou doença de longa duração (de mais de 6 meses de duração) a ___
# J00801      382-382   (1)   Alguma dessas doenças limita de alguma forma suas atividades habituais (trabalhar, ir à escola, brincar, afazeres domésticos, etc.)
# J009        383-383   (1)   ___ costuma procurar o mesmo lugar, mesmo médico ou mesmo serviço de saúde quando precisa de atendimento de saúde
# J01002      384-385   (2)   Quando está doente ou precisando de atendimento de saúde___ costuma procurar
# J01101      386-386   (1)   Quando ____ consultou um médico pela última vez
# J012        387-389   (3)   Quantas vezes ___ consultou um médico nos últimos 12 meses
# J01301      390-390   (1)   Quando ___ consultou um dentista pela última vez
# J014        391-391   (1)   Nas duas últimas semanas, ___ procurou algum lugar, serviço ou profissional de saúde para atendimento relacionado à própria saúde
# J01502      392-393   (2)   Qual foi o motivo principal pelo qual ___ procurou atendimento relacionado à própria saúde nas duas últimas semanas
# J01602      394-394   (1)   Onde ___ procurou o primeiro atendimento de saúde por este motivo nas duas últimas semanas
# J01701      395-395   (1)   Nessa primeira vez que procurou atendimento de saúde por este motivo, nas duas últimas semanas
# J01802      396-396   (1)   Por que motivo ___ não foi atendido(a) na primeira vez que procurou atendimento de saúde nas duas últimas semanas
# J019        397-398   (2)   Nas duas últimas semanas, quantas vezes ___ voltou a procurar atendimento de saúde por este mesmo motivo
# J02002      399-400   (2)   Onde ___ procurou o último atendimento de saúde por este motivo nas duas últimas semanas
# J021        401-401   (1)   Nessa última vez que procurou atendimento de saúde por este motivo, nas duas últimas semanas, ___ foi atendido (a)
# J022010     402-402   (1)   Por que motivo ___ não foi atendido (a) nessa última vez que procurou atendimento de saúde nas duas últimas semanas
# J023        403-403   (1)   Este serviço de saúde onde___ foi atendido era:
# J024        404-404   (1)   Este atendimento de saúde de ___ foi coberto por algum plano de saúde
# J025        405-405   (1)   ___ pagou algum valor por este atendimento de saúde recebido nas duas últimas semanas
# J026        406-406   (1)   O atendimento de ___ foi feito pelo SUS
# J02702      407-408   (2)   Qual foi o principal atendimento de saúde que ___ recebeu?
# J02901      409-409   (1)   Neste atendimento de ___, foi receitado algum medicamento
# J03001      410-410   (1)   __conseguiu obter os medicamentos receitados? (Leia as opções de resposta)
# J03102      411-411   (1)   Qual o principal motivo de ___ não ter conseguido obter todos os medicamentos receitados
# J032        412-412   (1)   Algum dos medicamentos foi coberto por plano de saúde
# J03301      413-413   (1)   Algum dos medicamentos foi obtido no programa Aqui Tem Farmácia Popular
# J034        414-414   (1)   Algum dos medicamentos foi obtido em serviço público de saúde
# J035        415-415   (1)   ___ pagou algum valor pelos medicamentos
# J03602      416-417   (2)   Nas duas últimas semanas, por que motivo ___ não procurou serviço de saúde
# J037        418-418   (1)   Nos últimos 12 meses, ___ ficou internado(a) em hospital por 24 horas ou mais
# J038        419-420   (2)   Nos últimos 12 meses, quantas vezes ___ esteve internado(a)
# J039        421-421   (1)   Qual foi o principal atendimento de saúde que ___recebeu quando esteve internado(a) (pela última vez) nos doze últimos meses
# J04001      422-423   (2)   Quanto tempo em meses o morador ficou internado
# J04002      424-425   (2)   Quanto tempo em dias o morador ficou internado
# J041        426-426   (1)   O estabelecimento de saúde em que ___ esteve internado(a) pela última vez nos últimos 12 meses era
# J042        427-427   (1)   A última internação de ___ nos últimos 12 meses foi coberta por algum plano de saúde
# J043        428-428   (1)   ___ pagou algum valor por esta última internação? (Entrevistador: se o(a) entrevistado(a) responder que pagou, mas teve reembolso total, marque a opção 2)
# J044        429-429   (1)   Esta última internação de ___ foi feita através do Sistema Único de Saúde (SUS)
# J046        430-430   (1)   Nos últimos 12 meses, ___ teve atendimento de urgência ou emergência no domicílio
# J047        431-431   (1)   Este atendimento foi coberto por algum plano de saúde
# J048        432-432   (1)   ___pagou algum valor por este atendimento? (Entrevistador: se o(a) entrevistado(a) responder que pagou, mas teve reembolso total, marque a opção 2)
# J049        433-433   (1)   Este atendimento foi feito através do Sistema Único de Saúde (SUS)
# J051        434-434   (1)   Neste atendimento, ___ foi transportado por ambulância para um serviço de saúde
# J052        435-435   (1)   O transporte foi feito por
# J05301      436-436   (1)   Nos últimos doze meses, ___ utilizou tratamento como acupuntura, homeopatia, plantas medicinais e fitoterapia, meditação, yoga, tai chi chuan, lian gong ou outra prática integrativa e complementar a saúde?
# J05402      437-437   (1)   Qual tratamento _________ fez uso Acupuntura
# J05403      438-438   (1)   Qual tratamento _________ fez uso Homeopatia
# J05404      439-439   (1)   Qual tratamento _________ fez uso plantas medicinais e fitoterapia
# J05405      440-440   (1)   Qual tratamento _________ fez uso auriculoterapia
# J05406      441-441   (1)   Qual tratamento _________ fez uso meditação
# J05407      442-442   (1)   Qual tratamento _________ fez uso Yoga
# J05408      443-443   (1)   Qual tratamento _________ fez uso Tai chi chuan, Lian gong, Qi gong
# J05409      444-444   (1)   Qual tratamento _________ fez uso Terapia comunitária integrativa
# J054010     445-445   (1)   Qual tratamento _________ fez uso Outro
# J056        446-446   (1)   ___ pagou algum valor por este(s) tratamento(s)
# J057        447-447   (1)   Este(s) tratamento(s) foi (foram) feito(s) através do Sistema Único de Saúde (SUS):
# J060        448-448   (1)   Informante do Módulo J
# K001        449-449   (1)   Em geral, que grau de dificuldade ___ tem para comer sozinho (a) com um prato colocado à sua frente, incluindo segurar um garfo, cortar alimentos e beber em um copo
# K004        450-450   (1)   Em geral, que grau de dificuldade ___ tem para tomar banho sozinho(a) incluindo entrar e sair do chuveiro ou banheira
# K007        451-451   (1)   Em geral, que grau de dificuldade ___ tem para ir ao banheiro sozinho(a) incluindo sentar e levantar do vaso sanitário
# K010        452-452   (1)   Em geral, que grau de dificuldade ___ tem para se vestir sozinho(a), incluindo calçar meias e sapatos, fechar o zíper, e fechar e abrir botões
# K013        453-453   (1)   Em geral, que grau de dificuldade ___ tem para andar em casa sozinho(a) de um cômodo a outro em um mesmo andar, como do quarto para a sala
# K016        454-454   (1)   Em geral, que grau de dificuldade ___ tem para deitar-se ou levantar-se da cama sozinho(a)
# K019        455-455   (1)   Em geral, que grau de dificuldade ___ tem para sentar-se ou levantar-se da cadeira sozinho
# K01901      456-456   (1)   ___ precisa de ajuda para realizar alguma(s) destas atividades (comer, tomar banho, ir ao banheiro, se vestir, andar em casa de um cômodo ao outro, deitar-se ou levantar-se da cama sozinho, sentar ou levantar da cadeira sozinho)
# K02001      457-457   (1)   ___  recebe ajuda para realizar alguma(s) destas atividades
# K02101      458-458   (1)   Na maioria das vezes, quem presta ajuda a ___ para realizar algumas dessas atividades
# K02102      459-459   (1)   Essa pessoa que lhe presta ajuda é remunerada por este serviço
# K022        460-460   (1)   Em geral, que grau de dificuldade ___ tem para fazer compras sozinho(a), por exemplo de alimentos, roupas ou medicamentos
# K025        461-461   (1)   Em geral, que grau de dificuldade ___ tem para administrar as finanças sozinho(a) (cuidar do seu próprio dinheiro)
# K028        462-462   (1)   Em geral, que grau de dificuldade ___ tem para tomar os remédios sozinho (a) (Engolir o remédio, organizar horário e capacidade de lembrar de tomar o remédio)
# K031        463-463   (1)   Em geral, que grau de dificuldade ___ tem para ir ao médico sozinho(a)
# K034        464-464   (1)   Em geral, que grau de dificuldade ___ tem para sair sozinho(a) utilizando um transporte como ônibus, metrô, táxi, carro, etc.
# K03401      465-465   (1)   ___ precisa de ajuda para realizar alguma(s) destas atividades (fazer compras, administrar as finanças, tomar os remédios, ir ao médico, sair utilizando um transporte como ônibus, metrô, táxi, carro, etc. )
# K03501      466-466   (1)   ___  recebe ajuda para realizar alguma(s) destas atividades
# K03601      467-467   (1)   Na maioria das vezes, quem presta ajuda a ___ para realizar algumas dessas atividades?
# K03602      468-468   (1)   Essa pessoa que lhe presta ajuda é remunerada por este serviço?
# K04301      469-469   (1)   ___faz uso de algum medicamento, que foi receitado por um médico, para uso regular ou contínuo (Diário)
# K04302      470-471   (2)   Quantos medicamentos diferentes de uso regular ou contínuo, receitados pelo médico, ___ usou nas duas últimas semanas
# K04401      472-472   (1)   Quando foi a última vez que ___ fez exame de vista por profissional de saúde
# K045        473-473   (1)   Algum médico já deu a ___ diagnóstico de catarata em uma ou em ambas as vistas
# K046        474-474   (1)   Houve indicação para realização de cirurgia nos olhos para retirar a catarata
# K047        475-475   (1)   ___ fez a cirurgia
# K048        476-476   (1)   Qual o principal motivo do(a) ___ não ter feito a cirurgia de catarata
# K050        477-477   (1)   ___ pagou algum valor pela cirurgia
# K051        478-478   (1)   A cirurgia foi feita através do Sistema Único de Saúde (SUS)
# K052        479-479   (1)   Nos últimos doze meses, ___ tomou vacina contra gripe
# K05302      480-481   (2)   Qual o principal motivo por não ter tomado a vacina contra gripe
# K05401      482-482   (1)   Nos últimos doze meses, ___ teve alguma queda
# K05402      483-483   (1)   Nos últimos doze meses, na ocasião dessa(as) queda(as) ocorrida(s) ___ procurou o serviço de saúde
# K055        484-484   (1)   NA
# K05601      485-485   (1)   ____ fez cirurgia por causa dessa fratura
# K05602      486-486   (1)   ___ teve colocação de prótese
# K062        487-487   (1)   Informante do Módulo K
# L01701      488-488   (1)   Leite materno?
# L01702      489-489   (1)   Outro leite ou derivados de leite?
# L01703      490-490   (1)   Água?
# L01704      491-491   (1)   Chá?
# L01705      492-492   (1)   Mingau?
# L01706      493-493   (1)   Frutas ou suco natural de frutas?
# L01707      494-494   (1)   Sucos artificiais?
# L01708      495-495   (1)   Verduras/legumes?
# L01709      496-496   (1)   Feijão ou outras leguminosas (lentilha, ervilha etc)?
# L01710      497-497   (1)   Carnes ou ovos?
# L01711      498-498   (1)   Batata e outros tubérculos e raízes (batata doce, mandioca)?
# L01712      499-499   (1)   Cereais e derivados (arroz, pão, cereal, macarrão, farinha, etc)?
# L01713      500-500   (1)   Biscoitos ou bolachas ou bolo?
# L01714      501-501   (1)   Doces, balas ou outros alimentos com açúcar?
# L01715      502-502   (1)   Refrigerantes?
# L01716      503-503   (1)   Outros?
# L018        504-504   (1)   Desde que ___________nasceu, tomou ou comeu outro alimento que não leite materno?
# L019        505-505   (1)   Alguma vez ___________ recebeu Sulfato Ferroso?
# L021        506-506   (1)   Foi realizado o teste do pezinho?
# L022        507-507   (1)   Quando foi realizado o teste do pezinho? 
# L023        508-508   (1)   Quanto tempo depois da realização do teste do pezinho, recebeu o resultado?
# L024        509-509   (1)   Foi realizado o teste de orelhinha?
# L025        510-510   (1)   Quando foi realizado o teste da orelhinha?
# L026        511-511   (1)   Quanto tempo depois da realização do teste da orelhinha você recebeu o resultado?
# L027        512-512   (1)   Foi realizado o teste do olhinho?
# L028        513-513   (1)   O teste do olhinho foi realizado nas primeiras 24 horas de vida?
# L029        514-514   (1)   Recebeu o resultado do olhinho na hora em que o exame foi realizado?
# L030        515-515   (1)   Foi realizado o teste do coraçãozinho?
# L031        516-516   (1)   O teste do coraçãozinho foi realizado entre 24 e 48 horas de vida quando ele (a) ainda estava na maternidade?
# L032        517-517   (1)   Recebeu o resultado do teste do coraçãozinho realizado?
# L033        518-518   (1)   O teste do coraçãozinho realizado deu resultado alterado?
# L034        519-519   (1)   Fez exame complementar?
# L035        520-520   (1)   Recebeu o cartão de vacinação ou caderneta de saúde da criança?
# L036        521-521   (1)   O(A) morador(a) mostrou a caderneta de saúde da criança
# L037        522-522   (1)   Vacina Penta (também chamada de Pentavalente, DTP/Hib/HB)
# L038        523-523   (1)   Vacina Poliomielite (também chamada de gotinha, VIP, VOP, PÓLIO, ANTIPÓLIO, POLIOMIELITE, SABIN)
# L039        524-524   (1)   Vacina Pneumocócica (também chamada de Pneumo 10, Pneumo 13, Pncc)
# L040        525-525   (1)   Vacina Tríplice Viral (também chamada SCR, TRIVIRAL, TV, MMR).
# L042        526-526   (1)   O informante desta parte foi:
# M001        527-527   (1)   Entrevista do adulto selecionado
# M002        528-528   (1)   Identificação da mãe do morador selecionado
# M00203      529-529   (1)   Morador selecionado está apto para responder?
# M00302      530-530   (1)   O informante desta parte é:
# M00303      531-531   (1)   Normalmente, quantos dias na semana o(a) Sr(a) se desloca(va) de casa para o(s) trabalho(s)
# M00401      532-533   (2)   Quanto tempo em horas o(a) Sr(a) gasta(va), normalmente, por dia, no deslocamento para o(s) seu(s) trabalho(s), considerando ida e volta
# M00402      534-535   (2)   Quanto tempo em minutos o(a) Sr(a) gasta, normalmente, por dia, no deslocamento para o(s) seu(s) trabalho(s), considerando ida e volta
# M005010     536-536   (1)   No(s) seu(s) trabalho(s), habitualmente, (s) o(a) Sr(a) trabalha(va) algum período de tempo entre as 8 horas da noite e às 5 horas da manhã
# M005011     537-538   (2)   Quantas horas trabalha(va) por dia, habitualmente, no período de 8 horas da noite e 5 horas da manhã
# M00601      539-539   (1)   Com que frequência, habitualmente, o(a) Sr(a) trabalha(va) no horário entre 8 horas da noite e 5 horas da manhã em algum dos seus trabalhos
# M007        540-540   (1)   Em algum dos seus trabalhos, o(a) Sr(a) trabalha(va) em regime de turnos ininterruptos, isto é, por 24 horas seguidas
# M008        541-541   (1)   Com que frequência o(a) Sr(a) trabalha(va) por 24 horas seguidas
# M009        542-542   (1)   O(a) Sr(a) normalmente trabalha(va) em ambientes
# M01001      543-543   (1)   Nos últimos 30 dias, alguém fumou no mesmo ambiente fechado onde o(a) Sr(a) trabalhava (todos os trabalhos)
# M011011     544-544   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está(estava) exposto(a) a algum destes fatores que podem afetar a sua saúde. Manuseio de substâncias químicas (agrotóxicos, gasolina, diesel, formol, chumbo, mercúrio, cromo, quimioterápicos etc.)
# M011021     545-545   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está exposto(a) a algum destes fatores que podem afetar a sua saúde Exposição a ruído (barulho intenso)
# M011031     546-546   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está exposto(a) a algum destes fatores que podem afetar a sua saúde Exposição longa ao sol
# M011041     547-547   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está exposto(a) a algum destes fatores que podem afetar a sua saúde Manuseio de material radioativo (transporte, recebimento, armazenagem, trabalho com raio-x)
# M011051     548-548   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está exposto(a) a algum destes fatores que podem afetar a sua saúde Manuseio de resíduos urbanos (lixo)
# M011061     549-549   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está exposto(a) a algum destes fatores que podem afetar a sua saúde Exposição a material biológico (sangue, agulhas, secreções)
# M011071     550-550   (1)   No(s) seu(s) trabalho(s), o(a) Sr(a) está exposto(a) a algum destes fatores que podem afetar a sua saúde Exposição à poeira mineral (pó de mármore, de areia, de brita, de vidro (sílica), de amianto (asbesto), de ferro ou aço)
# M01401      551-551   (1)   Com quantos familiares ou parentes ___ pode contar em momentos bons ou ruins
# M01501      552-552   (1)   Com quantos amigos próximos ___ pode contar em momentos bons ou ruins (Sem considerar os familiares ou parentes
# M01601      553-553   (1)   Nos últimos doze meses, com que frequência o(a) Sr(a) se reuniu com outras pessoas para prática de atividades esportivas, exercícios físicos, recreativos ou artísticos
# M01701      554-554   (1)   Nos últimos doze meses, com que frequência o(a) Sr(a) participou de reuniões de grupos como associações de moradores ou funcionários, movimentos sociais/comunitários, centros acadêmicos ou similares
# M01801      555-555   (1)   Nos últimos 12 meses, com que frequência o(a) Sr(a) fez trabalho voluntário não remunerado
# M01901      556-556   (1)   Nos últimos doze meses, com que frequência o(a) Sr(a) compareceu a atividades coletivas da sua religião ou de outra religião sem contar com situações como casamento, batizado, ou enterro)
# N001        557-557   (1)   Em geral, como o(a) Sr(a) avalia a sua saúde
# N00101      558-558   (1)   Considerando saúde como um estado de bem-estar físico e mental, e não somente a ausência de doenças, como você avalia o seu estado de saúde?
# N004        559-559   (1)   Quando o(a) Sr(a) sobe uma ladeira, um lance de escadas ou caminha rápido no plano, sente dor ou desconforto no peito
# N005        560-560   (1)   Quando o(a) Sr(a) caminha em lugar plano, em velocidade normal, sente dor ou desconforto no peito
# N006        561-561   (1)   O que o(a) Sr(a) faz se sente dor ou desconforto no peito
# N00701      562-562   (1)   Quando o(a) Sr(a) para, o que acontece com a dor ou desconforto no peito
# N008        563-563   (1)   O(A) Sr(a) pode me mostrar onde geralmente sente essa dor/desconforto no peito
# N010        564-564   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) teve problemas no sono, como dificuldade para adormecer, acordar frequentemente à noite ou dormir mais do que de costume?
# N011        565-565   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) teve problemas por não se sentir descansado(a) e disposto(a) durante o dia, sentindo-se cansado(a), sem ter energia?
# N012        566-566   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) teve pouco interesse ou não senitiu prazer em fazer as coisas?
# N013        567-567   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) teve problemas para se concentrar nas suas atividades habituais?
# N014        568-568   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) teve problemas na alimentação, como ter falta de apetite ou comer muito mais do que de costume?
# N015        569-569   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) teve lentidão para se movimentar ou falar, ou ao contrário ficou muito agitado(a) ou inquieto(a)?
# N016        570-570   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) se sentiu deprimido(a), “pra baixo” ou sem perspectiva?
# N017        571-571   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) se sentiu mal consigo mesmo, se achando um fracasso ou achando que decepcionou sua família?
# N018        572-572   (1)   Nas duas últimas semanas, com que frequência o(a) Sr(a) pensou em se ferir de alguma maneira ou achou que seria melhor estar morto?
# O00101      573-573   (1)   Atualmente, o(a) Sr(a) dirige automóvel (inclusive táxi, aplicativos de transporte e similares)
# O00401      574-574   (1)   Com que frequência o(a) Sr(a) usa cinto de segurança quando dirige automóvel (inclusive táxi, aplicativos de transporte e similares)?
# O00402      575-575   (1)   Com que frequência o(a) Sr(a) usa cinto de segurança quando anda no banco da frente como passageiro de automóvel (inclusive táxi, aplicativos de transporte e similares)?
# O00501      576-576   (1)   Com que frequência o(a) Sr(a) usa cinto de segurança quando anda no banco de trás de automóvel (inclusive táxi, aplicativos de transporte e similares)?
# O00201      577-577   (1)   Atualmente, o(a) Sr(a) dirige motocicleta
# O00701      578-578   (1)   Com que frequência o(a) Sr(a) usa capacete quando dirige motocicleta
# O00801      579-579   (1)   Com que frequência o(a) Sr(a) usa capacete quando anda como passageiro de motocicleta
# O00802      580-580   (1)   Com que frequência o (a) senhor (a) manuseia o celular durante a condução de moto ou automóvel (inclusive táxi, aplicativos de transporte e similares)?
# O00803      581-581   (1)   Com que frequência o (a) senhor (a) conduz moto ou automóvel (inclusive táxi, aplicativos de transporte e similares) acima da velocidade da via?
# O009        582-582   (1)   Nos últimos doze meses, o(a) Sr(a) se envolveu em algum acidente de trânsito no qual tenha sofrido lesões corporais (ferimentos)
# O00901      583-584   (2)   Quantos
# O010        585-585   (1)   Algum desses acidentes de trânsito ocorreu quando o(a) Sr(a) estava trabalhando, indo ou voltando do trabalho
# O01102      586-587   (2)   Durante o acidente de trânsito ocorrido nos últimos 12 meses, o(a) Sr(a) era: (Se houver mais de um, considere o mais grave)
# O01401      588-588   (1)   Por causa deste acidente de trânsito o(a) Sr(a) deixou de realizar quaisquer de suas atividades habituais (trabalhar, realizar afazeres domésticos, ir à escola etc.)?
# O01501      589-589   (1)   Para este acidente de trânsito, o(a) Sr(a) recebeu algum tipo de atendimento de saúde?
# O01602      590-591   (2)   Onde o(a) Sr(a) recebeu o primeiro atendimento de saúde
# O01702      592-592   (1)   Quem lhe prestou atendimento no local do acidente
# O019        593-593   (1)   Por causa deste acidente de trânsito, o(a) Sr(a) precisou ser internado por 24 horas ou mais? (Se houver mais de um, considere o mais grave)
# O02001      594-594   (1)   O Sr(a) tem alguma sequela física permanente decorrente deste acidente de trânsito? (Se houver mais de um, considere o mais grave)
# O021        595-595   (1)   Nos últimos doze meses o(a) Sr(a) se envolveu em algum acidente de trabalho? (Sem considerar os acidentes de trânsito e/ou de deslocamento para o trabalho)
# O02101      596-597   (2)   Quantos
# O02201      598-598   (1)   Como consequência desse acidente de trabalho, o(a) Sr(a) deixou de realizar quaisquer de suas atividades habituais (trabalhar, realizar afazeres domésticos, ir à escola etc.)?
# O023        599-599   (1)   Por causa deste acidente de trabalho, o(a) Sr(a) precisou ser internado por 24 horas ou mais? (Se houver mais de um, considere o mais grave)
# O02401      600-600   (1)   O(A) Sr(a) tem alguma sequela física permanente decorrente desse acidente de trabalho
# P00102      601-601   (1)   O(A) Sr(a) sabe seu peso?
# P00103      602-606   (5)   Peso - Informado (em kg)(3 inteiros e 1 casa decimal)
# P00104      607-611   (5)   Peso - Final (em kg)(3 inteiros e 1 casa decimal)
# P00201      612-612   (1)   Quanto tempo faz que o(a) Sr(a) se pesou da última vez?
# P00402      613-613   (1)   O(A) Sr(a) sabe sua altura? (mesmo que seja valor aproximado)
# P00403      614-616   (3)   Altura - Informada (em cm)(3 inteiros)
# P00404      617-619   (3)   Altura - Final (em cm)(3 inteiros)
# P00405      620-620   (1)   Marca de imputação para altura e/ou peso referido
# P005        621-621   (1)   A Sra está grávida no momento?
# P00601      622-622   (1)   Ontem o(a) Sr(a) comeu arroz, macarrão, polenta, cuscuz ou milho verde.
# P00602      623-623   (1)   Batata comum, mandioca/aipim/macaxeira, cará ou inhame.
# P00603      624-624   (1)   Feijão, ervilha, lentilha ou grão de bico.
# P00604      625-625   (1)   Carne de boi, porco, frango, peixe
# P00605      626-626   (1)   Ovo (frito, cozido ou mexido ).
# P00607      627-627   (1)   Alface, couve, brócolis, agrião ou espinfre.
# P00608      628-628   (1)   Abóbora, cenoura, batata doce ou quiabo/caruru.
# P00609      629-629   (1)   Tomate, pepino, abobrinha, berinjela, chuchu ou beterraba.
# P00610      630-630   (1)   Mamão, manga, melão amarelo ou pequi.
# P00611      631-631   (1)   Laranja, banana, maçã, abacaxi.
# P00612      632-632   (1)   Leite
# P00613      633-633   (1)   Amendoim, castanha de caju ou castanha do Brasil/Pará
# P00614      634-634   (1)   ONTEM o(a) Sr(a) tomou ou comeu:Refrigerante
# P00615      635-635   (1)   Suco de fruta em caixinha ou lata ou refresco em pó.
# P00616      636-636   (1)   Bebida achocolatada ou iogurte com sabor.
# P00617      637-637   (1)   Salgadinho de pacote ou biscoito/bolacha salgado.
# P00618      638-638   (1)   Biscoito/bolacha doce ou recheado ou bolo de pacote.
# P00619      639-639   (1)   Sorvete, chocolate, gelatina, flan ou outra sobremesa industrializada.
# P00620      640-640   (1)   Salsicha, linguiça, mortadela ou presunto.
# P00621      641-641   (1)   Pão de forma, de cachorro-quente ou de hambúrguer.
# P00622      642-642   (1)   Margarina, maionese, ketchup ou outros molhos industrializados.
# P00623      643-643   (1)   Macarrão instantâneo, sopa de pacote, lasanha congelada ou outro prato congelado comprado pronto industrilizado.
# P006        644-644   (1)   Em quantos dias da semana o(a) Sr(a) costuma comer feijão?
# P00901      645-645   (1)   Em quantos dias da semana, o(a) Sr(a) costuma comer pelo menos um tipo de verdura ou legume (sem contar batata, mandioca, cará ou inhame) como alface, tomate, couve, cenoura, chuchu, berinjela, abobrinha?
# P01001      646-646   (1)   Em geral, o(a) Sr(a) costuma comer esse tipo de verdura ou legume:
# P01101      647-647   (1)   Em quantos dias da semana o(a) Sr(a) costuma comer carne vermelha (boi, porco, cabrito, bode, ovelha etc.)?
# P013        648-648   (1)   Em quantos dias da semana o(a) Sr(a) costuma comer frango/galinha?
# P015        649-649   (1)   Em quantos dias da semana o(a) Sr(a) costuma comer peixe?
# P02001      650-650   (1)   Em quantos dias da semana o(a) Sr(a) costuma tomar suco de caixinha/lata ou refresco em pó ?
# P02101      651-651   (1)   Que tipo de suco de caixinha/lata ou refresco em pó o(a) Sr(a) costuma tomar? (Ler as opções de resposta)
# P01601      652-652   (1)   Em quantos dias da semana o(a) Sr(a) costuma tomar suco de fruta natural (incluída a polpa de fruta congelada)?
# P018        653-653   (1)   Em quantos dias da semana o(a) Sr(a) costuma comer frutas?
# P019        654-654   (1)   Em geral, quantas vezes por dia o(a) Sr(a) come frutas?
# P02002      655-655   (1)   Em quantos dias da semana o(a) Sr(a) costuma tomar refrigerante?
# P02102      656-656   (1)   Que tipo de refrigerante o(a) Sr(a) costuma tomar?
# P023        657-657   (1)   Em quantos dias da semana o(a) Sr(a) costuma tomar leite? (de origem animal: vaca, cabra, búfala etc.)
# P02401      658-658   (1)   Que tipo de leite o(a) Sr(a) costuma tomar?
# P02501      659-659   (1)   Em quantos dias da semana o(a) Sr(a) costuma comer alimentos doces como biscoito/bolacha recheado, chocolate, gelatina, balas e outros?
# P02602      660-660   (1)   Em quantos dias da semana o(a) Sr(a) costuma substituir a refeição do almoço por lanches rápidos como sanduíches, salgados, pizza, cachorro quente, etc?
# P02601      661-661   (1)   Considerando a comida preparada na hora e os alimentos industrializados, o(a) Sr(a) acha que o seu consumo de sal é:
# P027        662-662   (1)   Com que frequência o(a) Sr(a) costuma consumir alguma bebida alcoólica?
# P02801      663-663   (1)   Quantos dias por semana o(a) Sr(a) costuma consumir alguma bebida alcoólica?
# P029        664-665   (2)   Em geral, no dia que o(a) Sr(a) bebe, quantas doses de bebida alcoólica o(a) Sr(a) consome?
# P03201      666-666   (1)   Nos últimos trinta dias, o(a) Sr(a) chegou a consumir cinco ou mais doses de bebida alcoólica em uma única ocasião?
# P03202      667-668   (2)   Quando isso ocorreu, qual foi o número máximo de doses consumido em uma única ocasião?
# P03001      669-669   (1)   Nos últimos doze meses, quando consumiu bebida alcoólica, o(a) Sr(a) dirigiu logo depois de beber?
# P03301      670-670   (1)   Nos últimos doze meses, quantas vezes o(a) Sr(a) deixou de trabalhar, realizar afazeres domésticos, ir à escola, curso ou faculdade, fazer compras, etc. porque bebeu demais?
# P03302      671-671   (1)   Nos últimos doze meses, quantas vezes, depois/após ter bebido, o(a) Sr(a) não conseguiu lembrar o que aconteceu?
# P03303      672-672   (1)   Nos últimos doze meses, algum parente, amigo ou profissional de saúde disse que você estava bebendo demais ou para você parar de beber?
# P034        673-673   (1)   Nos últimos três meses, o(a) Sr(a) praticou algum tipo de exercício físico ou esporte?
# P035        674-674   (1)   Quantos dias por semana o(a) Sr(a) costuma  (costumava)praticar exercício físico ou esporte?
# P03701      675-676   (2)   Em geral, no dia que o(a) Sr(a) pratica exercício ou esporte, quanto tempo em horas dura essa atividade? Horas
# P03702      677-678   (2)   Em geral, no dia que o(a) Sr(a) pratica (praticava) exercício ou esporte, quanto tempo em minutos dura essa atividade?Minutos
# P036        679-680   (2)   Qual o exercício físico ou esporte que o(a) Sr(a) pratica (praticava) com mais frequência? (Anotar apenas o primeiro citado)
# P038        681-681   (1)   No seu trabalho, o(a) Sr(a) anda bastante a pé?
# P039        682-682   (1)   No seu trabalho, o(a) Sr(a) faz faxina pesada, carrega peso ou faz outra atividade pesada que requer esforço físico intenso?
# P03904      683-683   (1)   Em uma semana normal, em quantos dias, o(a) Sr(a) anda bastante a pé ou faz essas atividades pesadas ou que requerem esforço físico no seu trabalho?
# P03905      684-685   (2)   Em um dia normal, quanto tempo o(a) Sr(a) passa andando bastante a pé ou realizando essas atividades pesadas ou que requerem esforço físico no seu trabalho?Horas
# P03906      686-687   (2)   Em um dia normal, quanto tempo o(a) Sr(a) passa andando bastante a pé ou realizando atividades essas atividades pesadas ou que requerem esforço físico no seu trabalho? Minutos
# P040        688-688   (1)   Para ir ou voltar do trabalho, o(a) Sr(a) faz algum trajeto a pé ou de bicicleta?
# P04001      689-689   (1)   Quantos dias por semana o(a) Sr(a) faz algum trajeto a pé ou bicicleta?
# P04101      690-691   (2)   Quanto tempo o(a) Sr(a) gasta, por dia, para percorrer este trajeto a pé ou de bicicleta, considerando a ida e a volta do trabalho?Horas
# P04102      692-693   (2)   Quanto tempo o(a) Sr(a) gasta, por dia, para percorrer este trajeto a pé ou de bicicleta, considerando a ida e a volta do trabalho?Minutos
# P042        694-694   (1)   Nas suas atividades habituais (tais como ir a algum curso, escola ou clube ou levar alguém a algum curso, escola ou clube), quantos dias por semana o(a) Sr(a) faz alguma atividade que envolva deslocamento a pé ou bicicleta? (Exceto o trabalho)
# P04301      695-696   (2)   No dia em que o(a) Sr(a) faz essa(s) atividade(s), quanto tempo o(a) Sr(a) gasta no deslocamento a pé ou de bicicleta, considerando Ida e Volta?Horas
# P04302      697-698   (2)   No dia em que o(a) Sr(a) faz essa(s) atividade(s), quanto tempo o(a) Sr(a) gasta no deslocamento a pé ou de bicicleta, considerando Ida e Volta?Minutos
# P044        699-699   (1)   Nas suas atividades domésticas, o(a) Sr(a) faz faxina pesada, carrega peso ou faz outra atividade pesada que requer esforço físico intenso? (não considerar atividade doméstica remunerada)
# P04401      700-700   (1)   Em uma semana normal, nas suas atividades domésticas, em quantos dias o(a) Sr(a) faz faxina pesada ou realiza atividades que requerem esforço físico intenso? (não considerar atividade doméstica remunerada)
# P04405      701-702   (2)   Quanto tempo gasta, por dia, realizando essas atividades domésticas pesadas ou que requerem esforço físico intenso? (não considerar atividade doméstica remunerada) Horas
# P04406      703-704   (2)   Quanto tempo gasta, por dia, realizando essas atividades domésticas pesadas ou que requerem esforço físico intenso?
# P04501      705-705   (1)   Em média, quantas horas por dia o(a) Sr(a) costuma ficar assistindo televisão?
# P04502      706-706   (1)   Em um dia, quantas horas do seu tempo livre (excluindo o trabalho), o(a) Sr(a) costuma usar computador, tablet ou celular para lazer, tais como: utilizar redes sociais, para ver notícias, vídeos, jogar etc?
# P046        707-707   (1)   Perto do seu domicílio, existe algum lugar público (praça, parque, rua fechada, praia) para fazer caminhada, realizar exercício ou praticar esporte?
# P04701      708-708   (1)   O(A) Sr(a) conhece algum programa público de estímulo à prática de atividade física no seu município?
# P04801      709-709   (1)   O(A) Sr(a) participa desse programa público de estímulo à prática de atividade física no seu município?
# P04902      710-710   (1)   Qual o principal motivo de não participar?
# P050        711-711   (1)   Atualmente, o(a) Sr(a) fuma algum produto do tabaco?
# P051        712-712   (1)   E no passado, o(a) Sr(a) fumou algum produto do tabaco diariamente?
# P052        713-713   (1)   E no passado, o(a) Sr(a) fumou algum produto do tabaco?
# P053        714-715   (2)   Que idade o(a) Sr(a) tinha quando começou a fumar produto de tabaco diariamente?
# P05401      716-716   (1)   Em média, quanto fuma por dia ou por semana Cigarros industrializados
# P05402      717-718   (2)   Quantos por dia
# P05403      719-720   (2)   Quantos por semana
# P05404      721-721   (1)   Em média, quanto fuma por dia ou por semana Cigarros de palha ou enrolados a mão?
# P05405      722-723   (2)   Quantos por dia
# P05406      724-725   (2)   Quantos por semana
# P05407      726-726   (1)   Em média, quanto fuma por dia ou por semana Cigarros de cravo ou de Bali?
# P05408      727-728   (2)   Quantos por dia
# P05409      729-730   (2)   Quantos por semana
# P05410      731-731   (1)   Em média, quanto fuma por dia ou por semana Cachimbos (considere cachimbos cheios)?
# P05411      732-733   (2)   Quantos por dia
# P05412      734-735   (2)   Quantos por semana
# P05413      736-736   (1)   Em média, quanto fuma por dia ou por semana Charutos ou cigarrilhas?
# P05414      737-738   (2)   Quantos por dia
# P05415      739-740   (2)   Quantos por semana
# P05416      741-741   (1)   Em média, quanto fuma por dia ou por semana Narguilé (sessões)?
# P05417      742-743   (2)   Quantos por dia
# P05418      744-745   (2)   Quantos por semana
# P05419      746-746   (1)   Em média, quanto fuma por dia ou por semana Outro
# P05421      747-748   (2)   Quantos por dia
# P05422      749-750   (2)   Quantos por semana
# P055        751-751   (1)   Quanto tempo depois de acordar o(a) Sr(a) normalmente fuma pela primeira vez?
# P056        752-752   (1)   NA ÚLTIMA VEZ que o(a) Sr(a) comprou cigarros para uso próprio, quantos cigarros comprou? (Registre a quantidade e, quando necessário, registre os detalhes da unidade).
# P05601      753-754   (2)   Quantidade de cigarros
# P05602      755-756   (2)   Quantidade de maços
# P05603      757-758   (2)   Quantos cigarros havia em cada maço?
# P05604      759-760   (2)   Quantidade de pacotes
# P05605      761-762   (2)   Quantos maços havia em cada pacote?
# P057        763-770   (8)   No total, quanto o(a) Sr(a) pagou por essa compra?
# P058        771-771   (1)   Em média, quantos cigarros industrializados o(a) Sr(a) fumava por dia ou por semana?
# P05801      772-773   (2)   Quantos por dia
# P05802      774-775   (2)   Quantos por semana
# P05901      776-777   (2)   Número de anos que parou de fumar
# P05902      778-779   (2)   Número de meses que parou de fumar
# P05903      780-781   (2)   Número de semanas que parou de fumar
# P05904      782-783   (2)   Número de dias que parou de fumar
# P05905      784-784   (1)   Nos últimos doze meses, durante algum atendimento, por médico ou outro profissional de saúde, foi perguntado se o(a) Sr(a) fumava?
# P05906      785-785   (1)   Nos últimos doze meses, durante algum desses atendimentos o(a) Sr(a) foi aconselhado a parar de fumar?
# P060        786-786   (1)   Durante os últimos doze meses, o(a) Sr(a) tentou parar de fumar?
# P06101      787-787   (1)   Durante os últimos doze meses, quando o(a) Sr(a) tentou parar de fumar, usou aconselhamento por profissional de saúde incluindo unidades de saúde que oferecem tratamento para parar de fumar?
# P06102      788-788   (1)   O(A) Sr(a) pagou algum valor por esse aconselhamento?
# P06103      789-789   (1)   Esse aconselhamento foi feito pelo SUS?
# P06104      790-790   (1)   Durante os últimos 12 meses, quando o Sr(a) tentou parar de fumar, usou medicamento(s) que auxilia( m) as pessoas no processo de deixar de fumar, tais como adesivo, pastilha, spray, inalador, goma de mascar, bupropiona, champix/vareniclina, nortriptilina, Clonidina, etc?
# P06105      791-791   (1)   O(A) Sr(a) pagou algum valor por esse(s) medicamento(s)?
# P06106      792-792   (1)   Algum desses medicamentos foi obtido em serviço público de saúde?
# P06302      793-794   (2)   Durante os últimos 12 meses, por que o(a) Sr(a) não usou nem aconselhamento nem medicamento para tentar parar de fumar?
# P067        795-795   (1)   ATUALMENTE, o (a) Sr (a) masca fumo, usa rapé ou algum outro produto do tabaco que não faz fumaça?
# P06701      796-796   (1)   O(a) Sr(a) usa aparelhos eletrônicos com nicotina líquida ou folha de tabaco picado (cigarro eletrônico, narguilé eletrônico, cigarro aquecido ou outro dispositivo eletrônico para fumar ou vaporizar)?
# P068        797-797   (1)   Com que frequência alguém fuma dentro do seu domicílio?
# P069        798-798   (1)   Nos últimos trinta dias, o(a) Sr(a) viu alguma propaganda ou anúncio de cigarros nos pontos de venda de cigarros?
# P06901      799-799   (1)   Nos últimos 30 dias, o(a) Sr(a) viu alguma propaganda ou anúncio de cigarros na internet, incluindo redes sociais (Facebook, Instagram, Twitter, WhatsApp, YouTube, Snapchat etc)?
# P07004      800-800   (1)   Viu ou ouviu informações nos jornais ou revistas?
# P07005      801-801   (1)   Viu ou ouviu informações na televisão?
# P07006      802-802   (1)   Viu ou ouviu informações no rádio?
# P07007      803-803   (1)   Viu ou ouviu informações na internet, incluindo redes sociais?
# P07101      804-804   (1)   Nos últimos trinta dias, viu alguma foto ou advertência sobre os riscos de fumar nos maços de cigarros?
# P07201      805-805   (1)   NOS ÚLTIMOS 30 DIAS, as advertências nos maços de cigarro que o(a) Sr(a) viu o levaram a pensar em parar de fumar?
# Q00101      806-806   (1)   Quando foi a última vez que o (a) Sr(a) teve sua pressão arterial medida?
# Q00201      807-807   (1)   Algum médico já lhe deu o diagnóstico de hipertensão arterial (pressão alta)?
# Q00202      808-808   (1)   Essa hipertensão arterial (pressão alta) ocorreu apenas durante algum período de gravidez?
# Q003        809-810   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de hipertensão arterial (pressão alta)?
# Q00401      811-811   (1)   O(A) Sr(a) vai ao médico/serviço de saúde regularmente para acompanhamento da hipertensão arterial (pressão alta) ?
# Q00502      812-813   (2)   Qual o principal motivo do(a) Sr (a) não visitar o médico/serviço de saúde regularmente para acompanhamento da hipertensão arterial (pressão alta)?
# Q00503      814-814   (1)   Algum médico já lhe receitou algum medicamento para a hipertensão arterial (pressão alta)?
# Q00601      815-815   (1)   Nas duas últimas semanas, o(a) Sr(a) tomou os medicamentos para controlar a hipertensão arterial (pressão alta)?
# Q00602      816-816   (1)   Qual o principal motivo para o(a) Sr(a) não ter tomado os medicamentos receitados para a hipertensão arterial (pressão alta)?
# Q00801      817-817   (1)   Algum dos medicamentos para hipertensão arterial foi obtido no “Aqui tem farmácia popular”?
# Q009        818-818   (1)   Algum dos medicamentos para hipertensão arterial foi obtido em serviço público de saúde?
# Q010        819-819   (1)   O(A) Sr(a) pagou algum valor pelos medicamentos?
# Q01101      820-820   (1)   Quando foi a última vez que o(a) Sr(a) recebeu atendimento médico por causa da hipertensão arterial?
# Q01202      821-822   (2)   Na última vez que recebeu atendimento médico para hipertensão arterial, onde o(a) Sr(a) foi atendido?
# Q014        823-823   (1)   O(A) Sr(a) pagou algum valor por este atendimento? (Entrevistador: Se o(a) entrevistado(a) responder que pagou mas teve reembolso total, marque a opção 2)
# Q015        824-824   (1)   Esse atendimento foi feito pelo SUS?
# Q016        825-825   (1)   Na última consulta, o médico que o(a) atendeu era o mesmo das consultas anteriores?
# Q017        826-826   (1)   Na última consulta, o médico viu os exames das consultas passadas?
# Q018010     827-827   (1)   Orientações para manter uma alimentação saudável
# Q018011     828-828   (1)   Manter o peso adequado
# Q018012     829-829   (1)   Ingerir menos sal
# Q018013     830-830   (1)   Praticar atividade física regular
# Q018014     831-831   (1)   Não fumar
# Q018015     832-832   (1)   Não beber em excesso
# Q018016     833-833   (1)   Fazer o acompanhamento regular com profissional de saúde
# Q018017     834-834   (1)   Fazer uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan, liang gong ou alguma outra prática integrativa e complementar
# Q01910      835-835   (1)   Foi pedido exame de sangue?
# Q019101     836-836   (1)   Realizou o exame de sangue?
# Q01911      837-837   (1)   Foi pedido exame de urina?
# Q019111     838-838   (1)   Realizou o exame de urina?
# Q01912      839-839   (1)   Foi pedido eletrocardiograma?
# Q019121     840-840   (1)   Realizou o eletrocardiograma?
# Q01913      841-841   (1)   Foi pedido teste de esforço?
# Q019131     842-842   (1)   Realizou o teste de esforço?
# Q022        843-843   (1)   Em algum dos atendimentos para hipertensão arterial, houve encaminhamento para alguma consulta com médico especialista, tais como cardiologista ou nefrologista?
# Q02301      844-844   (1)   O(A) Sr(a) foi às consultas com o médico especialista?
# Q026        845-845   (1)   Alguma vez o(a) Sr(a) se internou por causa da hipertensão ou de alguma complicação?
# Q02701      846-846   (1)   Há quanto tempo foi a última internação por causa da hipertensão ou de alguma complicação?
# Q028        847-847   (1)   Em geral, em que grau a hipertensão ou alguma complicação da hipertensão limita as suas atividades habituais (como trabalhar, estudar, realizar afazeres domésticos etc.)?
# Q02901      848-848   (1)   Quando foi a última vez que o(a) Sr(a) fez exame de sangue para medir a glicemia, isto é, o açúcar no sangue?
# Q03001      849-849   (1)   Algum médico já lhe deu o diagnóstico de diabetes?
# Q03002      850-850   (1)   Esse diabetes ocorreu apenas durante algum período de gravidez?
# Q031        851-852   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico do diabetes?
# Q03201      853-853   (1)   O(A) Sr(a) vai ao médico/serviço de saúde regularmente para acompanhamento do diabetes?
# Q03302      854-855   (2)   Qual o principal motivo do(a) Sr(a) não visitar o médico/serviço de saúde regularmente para acompanhamento do diabetes?
# Q03303      856-856   (1)   Algum médico já lhe receitou algum medicamento oral para o diabetes?
# Q03403      857-857   (1)   Nas duas últimas semanas, por causa do diabetes, o(a) Sr(a) tomou os medicamentos orais para baixar o açúcar ?
# Q03404      858-859   (2)   Qual o principal motivo de ___ não ter tomado todos os medicamentos orais receitados para controlar o diabetes?
# Q03601      860-860   (1)   Algum dos medicamentos orais para diabetes foi obtido no “Aqui tem Farmácia Popular”?
# Q03701      861-861   (1)   Algum dos medicamentos orais para diabetes foi obtido em serviço público de saúde?
# Q03801      862-862   (1)   O(A) Sr(a) pagou algum valor pelos medicamentos orais para diabetes?
# Q03802      863-863   (1)   Algum médico já lhe receitou insulina para controlar o Diabetes?
# Q03803      864-864   (1)   Usou a insulina receitada na última prescrição?
# Q03804      865-865   (1)   Qual o principal motivo de ___não ter usado a insulina para controlar o diabetes?
# Q03805      866-866   (1)   A insulina foi obtida no Aqui tem Farmácia Popular (PFP)?
# Q03806      867-867   (1)   A insulina foi obtida em serviço público de saúde?
# Q03807      868-868   (1)   O(A) Sr(a) pagou pela insulina para controlar o diabetes?
# Q03901      869-869   (1)   Quando foi a última vez que o(a) Sr(a) recebeu atendimento médico por causa do diabetes?
# Q04002      870-871   (2)   Na última vez que recebeu atendimento médico para diabetes, onde o(a) Sr(a) foi atendido?
# Q042        872-872   (1)   O(A) Sr(a) pagou algum valor por esse atendimento?
# Q043        873-873   (1)   Esse atendimento foi feito pelo SUS?
# Q044        874-874   (1)   Na última consulta, o médico que o(a) atendeu era o mesmo das consultas anteriores?
# Q045        875-875   (1)   Na última consulta, o médico viu os exames das consultas passadas?
# Q046011     876-876   (1)   Orientações para manter uma alimentação saudável
# Q046012     877-877   (1)   Manter o peso adequado
# Q046013     878-878   (1)   Praticar atividade física regular
# Q046014     879-879   (1)   Não fumar
# Q046015     880-880   (1)   Não beber em excesso
# Q046016     881-881   (1)   Diminuir o consumo de massas e pães
# Q046017     882-882   (1)   Evitar o consumo de açúcar, bebidas açucaradas e doces
# Q046018     883-883   (1)   Medir a glicemia em casa
# Q046019     884-884   (1)   Examinar os pés regularmente
# Q046020     885-885   (1)   Fazer uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan, liang gong ou alguma outra prática integrativa e complementar
# Q046021     886-886   (1)   Fazer acompanhamento regular com profissional de saúde
# Q04707      887-887   (1)   Foi pedido Glicemia (açúcar no sangue) ?
# Q047071     888-888   (1)   Realizou o exame?
# Q04708      889-889   (1)   Foi pedido Hemoglobina glicada?
# Q047081     890-890   (1)   Realizou o exame?
# Q04709      891-891   (1)   Foi pedido curva glicêmica?
# Q047091     892-892   (1)   Realizou o exame?
# Q04710      893-893   (1)   Foi pedido exame de urina?
# Q047101     894-894   (1)   Realizou o exame?
# Q04711      895-895   (1)   Foi pedido colesterol e/ou triglicerídeos?
# Q047111     896-896   (1)   Realizou o exame?
# Q050        897-897   (1)   Em algum dos atendimentos para diabetes, houve encaminhamento para alguma consulta com médico especialista, tal como cardiologista, endocrinologista, nefrologista ou oftalmologista?
# Q05101      898-898   (1)   O(A) Sr(a) foi às consultas com médico especialista?
# Q05301      899-899   (1)   Quando foi a última vez que realizaram um exame de vista ou fundo de olho em que dilataram sua pupila?
# Q05401      900-900   (1)   Quando foi a última vez que um médico ou profissional de saúde examinou seus pés para verificar sensibilidade ou presença de feridas ou irritações?
# Q055011     901-901   (1)   Problemas na vista
# Q055012     902-902   (1)   Infarto ou AVC (Acidente Vascular cerebral) /derrame ou outro problema circulatório
# Q055013     903-903   (1)   Problema nos rins
# Q055014     904-904   (1)   Úlcera/ferida nos pés ou amputação de membros (pés, pernas, mãos ou braços)
# Q055015     905-905   (1)   Coma diabético
# Q055016     906-906   (1)   Outro (Especifique)
# Q056        907-907   (1)   Alguma vez o(a) Sr(a) se internou por causa do diabetes ou de alguma complicação?
# Q05701      908-908   (1)   Há quanto tempo foi a última internação por causa do diabetes ou de alguma complicação?
# Q058        909-909   (1)   Em geral, em que grau o diabetes ou alguma complicação do diabetes limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q05901      910-910   (1)   Quando foi a última vez que o(a) Sr(a) fez exame de sangue para medir o colesterol e triglicerídeos?
# Q060        911-911   (1)   Algum médico já lhe deu o diagnóstico de colesterol alto?
# Q061        912-913   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de colesterol alto?
# Q06207      914-914   (1)   Recomendação para manter uma alimentação saudável
# Q06208      915-915   (1)   Recomendação para manter o peso adequado
# Q06209      916-916   (1)   Recomendação para praticar atividade física regular
# Q06210      917-917   (1)   Recomendação para tomar medicamentos
# Q06211      918-918   (1)   Recomendação para não fumar
# Q06212      919-919   (1)   Recomendação para fazer acompanhamento regular com profissional de saúde
# Q06306      920-920   (1)   Algum médico já lhe deu o diagnóstico de uma doença do coração, tal como infarto, angina, insuficiência cardíaca ou outra?
# Q06307      921-921   (1)   Infarto
# Q06308      922-922   (1)   Angina
# Q06309      923-923   (1)   Insuficiência cardíaca
# Q06310      924-924   (1)   Arritmia
# Q06311      925-925   (1)   Outra
# Q064        926-927   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico da doença do coração?
# Q06506      928-928   (1)   Faz atualmente por causa da doença do coração: Dieta?
# Q06507      929-929   (1)   Faz atualmente por causa da doença do coração: prática de atividade física regular?
# Q06508      930-930   (1)   Faz atualmente por causa da doença do coração: toma medicamentos regularmente?
# Q06509      931-931   (1)   Faz atualmente por causa da doença do coração acompanhamento regular?
# Q06601      932-932   (1)   O(A) Sr(a) já fez alguma cirurgia de ponte de safena ou cateterismo com colocação de stent ou angioplastia?
# Q067        933-933   (1)   Em geral, em que grau a doença do coração limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q068        934-934   (1)   Algum médico já lhe deu o diagnóstico de AVC (Acidente Vascular Cerebral) ou derrame?
# Q070        935-936   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico do derrame (ou AVC)?
# Q07208      937-937   (1)   Faz atualmente por causa do derrame (ou AVC) Dieta?
# Q07209      938-938   (1)   Faz atualmente por causa do derrame (ou AVC) Fisioterapia?
# Q07210      939-939   (1)   Faz atualmente por causa do derrame (ou AVC) Outras terapias de reabilitação?
# Q07211      940-940   (1)   Faz atualmente por causa do derrame (ou AVC) Toma aspirina regularmente?
# Q07212      941-941   (1)   Faz atualmente por causa do derrame (ou AVC) Toma outros medicamentos?
# Q07213      942-942   (1)   Faz acompanhamento regular com profissional de saúde?
# Q073        943-943   (1)   Em geral, em que grau o derrame (ou AVC) limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q074        944-944   (1)   Algum médico já lhe deu o diagnóstico de asma (ou bronquite asmática)?
# Q075        945-946   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de asma?
# Q076        947-947   (1)   Nos últimos doze meses, o(a) Sr(a) teve alguma crise de asma?
# Q07601      948-948   (1)   Algum médico já lhe receitou algum medicamento para asma (ou bronquite asmática)?
# Q07704      949-949   (1)   . Nas duas últimas semanas o(a) Sr(a) usou os medicamentos orais por causa da asma (ou bronquite asmática) ?
# Q07705      950-950   (1)   Algum dos medicamentos orais para asma (ou bronquite asmática) foi obtido no “Aqui tem Farmácia Popular”?
# Q07706      951-951   (1)   Algum dos medicamentos orais para asma (ou bronquite asmática) foi obtido em serviço público de saúde?
# Q07707      952-952   (1)   O(A) Sr(a) pagou algum valor pelos medicamentos orais para asma?
# Q07708      953-953   (1)   Nas duas últimas semanas o(a) Sr(a) usou aerossóis (bombinha) por causa da asma (ou bronquite asmática)
# Q07709      954-954   (1)   Algum dos aerossóis (bombinha) para asma (ou bronquite asmática) foi obtido no “Aqui tem Farmácia Popular”?
# Q07710      955-955   (1)   Algum dos aerossóis (bombinha) para asma (ou bronquite asmática) foi obtido em serviço público de saúde?
# Q07711      956-956   (1)   O(A) Sr(a) pagou algum valor pelos aerossóis (bombinha) para asma?
# Q078        957-957   (1)   Em geral, em que grau a asma limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos, etc.)?
# Q079        958-958   (1)   Algum médico já lhe deu o diagnóstico de artrite ou reumatismo?
# Q080        959-960   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de artrite ou reumatismo?
# Q08107      961-961   (1)   Recomendação para praticar atividade física regularmente
# Q08108      962-962   (1)   Recomendação para Fazer fisioterapia
# Q08109      963-963   (1)   Recomendação para Usar medicamentos ou injeções
# Q08110      964-964   (1)   Recomendação para Fazer uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan ou alguma outra prática integrativa e complementar
# Q08111      965-965   (1)   Recomendação para Fazer acompanhamento regular com profissional de saúde
# Q082        966-966   (1)   O(A) Sr(a) já fez alguma cirurgia por causa da artrite ou reumatismo?
# Q083        967-967   (1)   Em geral, em que grau a artrite ou reumatismo limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos, etc.)?
# Q084        968-968   (1)   O(a) Sr(a) tem algum problema crônico de coluna, como dor crônica nas costas ou no pescoço, lombalgia, dor ciática, problemas nas vértebras ou disco?
# Q085        969-970   (2)   Que idade o(a) Sr(a) tinha quando começou o problema na coluna?
# Q08607      971-971   (1)   Pratica exercício regularmente por causa do problema na coluna
# Q08608      972-972   (1)   Faz fisioterapia por causa do problema na coluna
# Q08609      973-973   (1)   Usa medicamentos ou injeções
# Q08610      974-974   (1)   Faz uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan ou alguma outra prática integrativa e complementar por causa do problema na coluna
# Q08611      975-975   (1)   Faz acompanhamento regular com profissional de saúde por causa do problema na coluna
# Q087        976-976   (1)   Em geral, em que grau o problema na coluna limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos, etc.)?
# Q088        977-977   (1)   Algum médico já lhe deu o diagnóstico de DORT?
# Q08901      978-979   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de DORT?
# Q09007      980-980   (1)   Recomendado para DORT Praticar exercício regularmente
# Q09008      981-981   (1)   Recomendado para DORT Fazer fisioterapia
# Q09009      982-982   (1)   Recomendado para DORT Usar medicamentos ou injeções
# Q09010      983-983   (1)   Recomendado para DORT Fazer uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan ou alguma outra prática integrativa e complementar
# Q09011      984-984   (1)   Recomendado para DORT Fazer acompanhamento regular com profissional de saúde
# Q091        985-985   (1)   Em geral, em que grau o DORT limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q092        986-986   (1)   Algum médico ou profissional de saúde mental (como psiquiatra ou psicólogo) já lhe deu o diagnóstico de depressão?
# Q09201      987-987   (1)   Algum médico já lhe receitou algum medicamento para depressão?
# Q09202      988-988   (1)   Nas duas últimas semanas o(a) senhor(a) usou algum medicamento para depressão?
# Q09301      989-990   (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de depressão?
# Q094        991-991   (1)   O(A) Sr(a) vai ao médico/serviço de saúde regularmente por causa da depressão ou só quando tem algum problema?
# Q09502      992-993   (2)   Qual o principal motivo do(a) Sr(a) não visitar o médico/serviço de saúde regularmente por causa da depressão?
# Q09605      994-994   (1)   Por causa da depressão Faz psicoterapia
# Q09606      995-995   (1)   Por causa da depressão Toma medicamentos
# Q09607      996-996   (1)   Por causa da depressão Faz uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan, liang gong ou alguma outra prática integrativa e complementar
# Q098        997-997   (1)   Algum dos medicamentos para depressão foi obtido em serviço público de saúde?
# Q100        998-998   (1)   O(A) Sr(a) pagou algum valor pelos medicamentos?
# Q10101      999-999   (1)   Quando foi a última vez que o(a) Sr(a) recebeu atendimento médico por causa da depressão?
# Q10202      1000-1001 (2)   Na última vez que recebeu assistência médica para depressão, onde o(a) Sr(a) foi atendido?
# Q104        1002-1002 (1)   O(A) Sr(a) pagou algum valor por esse atendimento?
# Q105        1003-1003 (1)   Esse atendimento foi feito pelo SUS?
# Q106        1004-1004 (1)   Em algum dos atendimentos para depressão, houve encaminhamento para algum acompanhamento com profissional de saúde mental, como psiquiatra ou psicólogo?
# Q10701      1005-1005 (1)   O(A) Sr(a) conseguiu ir às consultas com profissional especialista de saúde mental?
# Q109        1006-1006 (1)   Em geral, em que grau a depressão limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos, etc.)?
# Q11006      1007-1007 (1)   Algum médico ou profissional de saúde (como psiquiatra ou psicólogo) já lhe deu o diagnóstico de outra doença mental, como transtorno de ansiedade, síndrome do pânico, esquizofrenia, transtorno bipolar, psicose ou TOC (Transtorno Obsessivo Compulsivo) etc?
# Q11007      1008-1008 (1)   Diagnóstico de Esquizofrenia
# Q11008      1009-1009 (1)   Diagnóstico de Transtorno bipolar
# Q11009      1010-1010 (1)   Diagnóstico de TOC (Transtorno obsessivo compulsivo)
# Q11010      1011-1011 (1)   Outro diagnóstico
# Q111        1012-1013 (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de doença mental?
# Q11201      1014-1014 (1)   O(A) Sr(a) visita o médico/serviço de saúde regularmente por causa dessa doença mental ou só quando tem algum problema?
# Q11405      1015-1015 (1)   Por causa da doença mental faz psicoterapia
# Q11406      1016-1016 (1)   Por causa da doença mental usa medicamentos ou injeções
# Q11407      1017-1017 (1)   Por causa da doença mental Faz uso de acupuntura, plantas medicinais e fitoterapia, homeopatia, meditação, yoga, tai chi chuan ou alguma outra prática integrativa e complementar
# Q11408      1018-1018 (1)   Por causa da doença mental Faz acompanhamento regular com profissional de saúde
# Q115        1019-1019 (1)   Em geral, em que grau essa doença mental limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q11604      1020-1020 (1)   Algum médico já lhe deu o diagnóstico de alguma outra doença crônica no pulmão, tais como enfisema pulmonar, bronquite crônica ou DPOC (Doença Pulmonar Obstrutiva Crônica)?
# Q11605      1021-1021 (1)   Diagnóstico de enfisema pulmonar
# Q11606      1022-1022 (1)   Diagnóstico de bronquite crônica
# Q11607      1023-1023 (1)   Diagnóstico de outro
# Q11701      1024-1025 (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico dessa(s) doença(s) no pulmão?
# Q11806      1026-1026 (1)   Por causa da doença no pulmão Usa medicamentos (inaladores, aerossol ou comprimidos)
# Q11807      1027-1027 (1)   Por causa da doença no pulmão Usa oxigênio
# Q11808      1028-1028 (1)   Por causa da doença no pulmão Fisioterapia respiratória
# Q11809      1029-1029 (1)   Por causa da doença no pulmão Faz acompanhamento regular com profissional de saúde
# Q119        1030-1030 (1)   Em geral, em que grau a doença do pulmão limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q120        1031-1031 (1)   Algum médico já lhe deu diagnóstico de câncer?
# Q12102      1032-1032 (1)   Foi um diagnóstico de câncer de pele?
# Q12103      1033-1033 (1)   O câncer de pele diagnosticado foi do tipo melanoma?
# Q12104      1034-1034 (1)   Diagnóstico de outro câncer? Pulmão
# Q12105      1035-1035 (1)   Diagnóstico de outro câncer? Cólon e reto (intestino)
# Q12106      1036-1036 (1)   Diagnóstico de outro câncer? Estômago
# Q12107      1037-1037 (1)   Diagnóstico de outro câncer? Mama (só para mulheres)
# Q12108      1038-1038 (1)   Diagnóstico de outro câncer? Colo de útero (só para mulheres)
# Q12109      1039-1039 (1)   Diagnóstico de outro câncer? Próstata (só para homens)
# Q121010     1040-1040 (1)   Diagnóstico de outro câncer? Boca, Orofaringe ou Laringe
# Q121011     1041-1041 (1)   Diagnóstico de outro câncer? Bexiga
# Q121012     1042-1042 (1)   Diagnóstico de outro câncer? Linfoma ou leucemia
# Q121013     1043-1043 (1)   Diagnóstico de outro câncer? Cérebro
# Q121014     1044-1044 (1)   Diagnóstico de outro câncer? Ovário (só para mulheres)
# Q121015     1045-1045 (1)   Diagnóstico de outro câncer? Tireoide
# Q121016     1046-1046 (1)   Diagnóstico de outro câncer?
# Q12201      1047-1048 (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de doença mental?
# Q12301      1049-1049 (1)   Em geral, seu tratamento, ou algum problema provocado pelo câncer, limita as suas atividades profissionais ou habituais (tais como trabalhar, realizar afazeres domésticos, etc.)?
# Q124        1050-1050 (1)   Algum médico já lhe deu o diagnóstico de insuficiência renal crônica?
# Q125        1051-1052 (2)   Que idade o(a) Sr(a) tinha no primeiro diagnóstico de insuficiência renal crônica?
# Q12501      1053-1053 (1)   O Sr(a) fez transplante de rim, por causa da insuficiência renal crônica?
# Q12607      1054-1054 (1)   Toma medicamentos por causa da insuficiência renal crônica?
# Q12608      1055-1055 (1)   Hemodiálise por causa da insuficiência renal crônica?
# Q12609      1056-1056 (1)   Diálise peritoneal por causa da insuficiência renal crônica?
# Q12610      1057-1057 (1)   Faz acompanhamento regular com profissional de saúde?
# Q127        1058-1058 (1)   Em geral, em que grau a insuficiência renal crônica limita as suas atividades habituais (tais como trabalhar, realizar afazeres domésticos etc.)?
# Q128        1059-1059 (1)   Algum médico já lhe deu algum diagnóstico de outra doença crônica (física ou mental) ou doença de longa duração (de mais de 6 meses de duração)?
# Q132        1060-1060 (1)   Nas últimas duas semanas, o(a) Sr(a) fez uso de algum medicamento para dormir?
# Q133        1061-1062 (2)   Nas últimas duas semanas, por quantos dias usou o medicamento para dormir?
# Q134        1063-1063 (1)   O medicamento que o(a) Sr(a) usa (usou) para dormir foi receitado por médico?
# R00101      1064-1064 (1)   Quando foi a última vez que a Sra fez exame preventivo para câncer de colo do útero
# R002010     1065-1066 (2)   Qual o principal motivo da Sra não ter feito exame preventivo nos últimos três anos
# R004        1067-1067 (1)   A Sra pagou algum valor pelo último exame preventivo para câncer do colo do útero? (Entrevistador: Se a entrevistada responder que pagou, mas teve reembolso, marque a opção 2)
# R005        1068-1068 (1)   O último exame preventivo para câncer do colo do útero foi feito através do Sistema Único de Saúde (SUS)
# R00601      1069-1069 (1)   Quanto tempo depois de ter realizado o último exame preventivo a Sra recebeu o resultado
# R007        1070-1070 (1)   Após receber o resultado do exame, a Sra foi encaminhada a alguma consulta com ginecologista ou outro médico especialista
# R008        1071-1071 (1)   A Sra foi à consulta
# R009010     1072-1073 (2)   Qual o principal motivo da Sra não ter ido à consulta
# R010        1074-1074 (1)   A sra já foi submetida a cirurgia para retirada do útero?
# R011        1075-1075 (1)   Segundo o médico, qual o motivo da retirada do útero?
# R012        1076-1077 (2)   Que idade a sra tinha quando foi submetida à cirurgia?
# R013        1078-1078 (1)   Quando foi a última vez que um médico ou enfermeiro fez o exame clínico das suas mamas
# R014        1079-1079 (1)   Algum médico já lhe solicitou um exame de mamografia
# R015        1080-1080 (1)   A Sra fez o exame de mamografia
# R01701      1081-1081 (1)   Quando foi a última vez que a Sra fez um exame de mamografia
# R019        1082-1082 (1)   A Sra pagou algum valor pela última mamografia?
# R020        1083-1083 (1)   A última mamografia foi feita através do Sistema Único de Saúde (SUS)
# R02101      1084-1084 (1)   Quanto tempo depois de ter realizado o último exame de mamografia a Sra recebeu o resultado
# R022        1085-1085 (1)   Após receber o resultado da mamografia, a Sra foi encaminhada para consulta com médico especialista
# R023        1086-1086 (1)   A Sra foi à consulta com o especialista
# R02402      1087-1088 (2)   Qual o principal motivo da Sra não ter ido à consulta com o especialista
# R025        1089-1090 (2)   Com que idade a sra ficou menstruada pela primeira vez?
# R026        1091-1091 (1)   A sra ainda fica menstruada?
# R027        1092-1093 (2)   Com que idade a sra parou de menstruar?
# R028        1094-1094 (1)   A sra já entrou na menopausa?
# R029        1095-1095 (1)   Alguma vez a sra fez ou faz tratamento hormonal para alívio dos sintomas da menopausa (com comprimidos, adesivos, gel ou injeções)?
# R030        1096-1096 (1)   Este medicamento foi receitado por médico?
# R031        1097-1097 (1)   Nos últimos 12 meses, a sra teve relações sexuais?
# R032        1098-1098 (1)   Nos últimos 12 meses, a sra participou de grupo de planejamento familiar?
# R033        1099-1099 (1)   E o seu parceiro participou de grupo de planejamento familiar?
# R034        1100-1100 (1)   A sra usa algum método para evitar a gravidez atualmente?
# R035        1101-1101 (1)   Qual o principal motivo de não evitar a gravidez?
# R03601      1102-1102 (1)   Pilula?
# R03602      1103-1103 (1)   Tabela?
# R03603      1104-1104 (1)   Camisinha masculina?
# R03604      1105-1105 (1)   Camisinha feminina?
# R03605      1106-1106 (1)   Diafragma?
# R03606      1107-1107 (1)   DIU?
# R03607      1108-1108 (1)   Contraceptivo injetável?
# R03608      1109-1109 (1)   Implantes (Norplant)?
# R03609      1110-1110 (1)   Creme/óvulo?
# R03610      1111-1111 (1)   Píulula do dia seguinte?
# R03611      1112-1112 (1)   Outro
# R037        1113-1113 (1)   A sra e/ou seu companheiro já fizeram ou fazem algum tratamento para engravidar?
# R038        1114-1114 (1)   Há quanto tempo a sra está tentando engravidar?
# S065        1115-1115 (1)   Alguma vez ficou grávida, mesmo que a gravidez não tenha chegado até o final?
# S066        1116-1117 (2)   Quantos partos a Sra já teve?
# S06701      1118-1119 (2)   Em que data foi o último parto?
# S06702      1120-1121 (2)   Em que data foi o último parto?
# S06703      1122-1125 (4)   Em que data foi o último parto?
# S068        1126-1126 (1)   Quando estava grávida fez alguma consulta de pré-natal?
# S06901      1127-1128 (2)   Quantas tempo de gravidez tinha quando fez a primeira consulta pré-natal?
# S06902      1129-1130 (2)   Quantas tempo de gravidez tinha quando fez a primeira consulta pré-natal?
# S070        1131-1131 (1)   Quantas consultas de pré-natal fez durante esta gravidez?
# S071        1132-1132 (1)   Você fez a maioria das consultas do pré-natal em serviço de saúde de:
# S072        1133-1133 (1)   Pagou por alguma consulta de pré-natal?
# S073        1134-1134 (1)   As consultas do pré-natal foram feitas através do Sistema Único de Saúde (SUS)?
# S074        1135-1135 (1)   Nesta gravidez, quem a atendeu na maioria das consultas?
# S075        1136-1136 (1)   Nesta gravidez, você tinha uma caderneta/cartão da gestante?
# S076        1137-1137 (1)   Nesta gravidez, você fez algum exame de sangue, sem considerar o teste de gravidez?
# S077        1138-1138 (1)   Nesta gravidez, você fez algum exame de urina, sem considerar o teste de gravidez?
# S07901      1139-1139 (1)   Durante o pré-natal, em quantas consultas mediram sua pressão arterial?
# S07902      1140-1140 (1)   Durante o pré-natal, em quantas consultas mediram o seu peso?
# S07903      1141-1141 (1)   Durante o pré-natal, em quantas consultas mediram sua barriga?
# S07904      1142-1142 (1)   Durante o pré-natal, em quantas consultas ouviram o coração do bebê?
# S07905      1143-1143 (1)   Durante o pré-natal, em quantas consultas examinaram suas mamas?
# S080        1144-1144 (1)   Durante o pré-natal de (nome) foi realizado teste∕ exame para sífilis?
# S081        1145-1145 (1)   Recebeu ou foi informada sobre o resultado do teste∕ exame para sífilis antes do parto?
# S082        1146-1146 (1)   Qual foi o resultado do teste / exame para sífilis?
# S083        1147-1147 (1)   Recebeu tratamento para sífilis?
# S084        1148-1148 (1)   Foi solicitado teste/exame de sífilis para o seu parceiro(a)?
# S085        1149-1149 (1)   O seu parceiro recebeu o resultado do teste∕ exame para sífilis antes do parto?
# S086        1150-1150 (1)   Qual foi o resultado do teste∕ exame para sífilis do seu parceiro?
# S087        1151-1151 (1)   O seu parceiro foi tratado?
# S088        1152-1152 (1)   Durante o pré-natal foi realizado teste∕ exame para hepatite B?
# S089        1153-1153 (1)   Recebeu o resultado da Hepatite B antes do parto?
# S090        1154-1154 (1)   Durante o pré-natal foi solicitado o teste∕ exame para HIV/AIDS?
# S091        1155-1155 (1)   Neste pré-natal foi realizado teste∕ exame para HIV/AIDS?
# S092        1156-1156 (1)   Recebeu o resultado do teste∕ exame para HIV/AIDS antes do parto?
# S095        1157-1157 (1)   Durante o pré-natal a Sra foi orientada a usar preservativo?
# S096        1158-1158 (1)   Quanto tempo antes do parto a Sra foi à última consulta do pré-natal?
# S097        1159-1159 (1)   Durante este pré-natal você foi informada/orientada pelo serviço de saúde/profissional de saúde sobre a maternidade para qual deveria se dirigir no momento do parto?
# S098        1160-1160 (1)   Quando estava grávida tomou alguma injeção para prevenir o bebê contra difteria e tétano (mal dos sete dias) – dT ou dTpa?
# S099        1161-1161 (1)   Quantas doses dessa injeção tomou durante esta gravidez?
# S09901      1162-1162 (1)   Número de doses
# S109        1163-1163 (1)   Seu(sua) filho(a) foi pesado ao nascer?
# S110        1164-1164 (1)   Qual foi o peso dele(a) ao nascer?
# S11001      1165-1168 (4)   Peso ao nascer (em quilogramas)
# S111        1169-1169 (1)   Quem fez o parto?
# S112        1170-1171 (2)   Onde foi realizado o parto?
# S113        1172-1172 (1)   Pagou algum valor pelo parto?
# S114        1173-1173 (1)   O parto foi feito através do Sistema Único de Saúde (SUS)?
# S115        1174-1174 (1)   Qual foi o tipo de parto?
# S116        1175-1175 (1)   Nesta gravidez, entrou em trabalho de parto?
# S117        1176-1176 (1)   Qual o principal motivo de ter tido parto cesáreo?
# S118        1177-1177 (1)   Quantas semanas de gravidez tinha no momento do parto?
# S11801      1178-1179 (2)   Quantidade de semanas
# S119        1180-1180 (1)   Neste parto fizeram em você a episiotomia (aquele corte na vagina)?
# S120        1181-1181 (1)   Neste trabalho de parto foi oferecido algum método para alívio da dor?
# S121        1182-1182 (1)   Neste trabalho de parto foi utilizado algum método para alívio da dor?
# S122        1183-1183 (1)   Qual foi o método utilizado para o alívio da dor?
# S123        1184-1184 (1)   Alguém conhecido ficou com você durante todo o período de parto (pré-parto, parto e pós-parto)?
# S124        1185-1185 (1)   Em algum momento esse acompanhante foi o pai da criança?
# S125        1186-1186 (1)   Teve alguma complicação durante o parto?
# S126        1187-1187 (1)   Você teve alguma complicação após o parto?
# S127        1188-1188 (1)   Por causa dessa complicação precisou ser internada?
# S128        1189-1189 (1)   O parto foi realizado no estabelecimento de saúde indicado no pré-natal?
# S129        1190-1190 (1)   Quantos serviços de saúde procurou quando entrou em trabalho de parto para que seu(sua) filho(a) pudesse nascer?
# S130        1191-1191 (1)   Durante a primeira hora após o nascimento, seu(sua) filho(a) foi colocado(a) em contato com você pele a pele?
# S131        1192-1192 (1)   Depois do nascimento, ele(a) ficou com você no quarto até a alta hospitalar?
# S132        1193-1193 (1)   Seu(sua) filho(a) saiu do hospital junto com você?
# S133        1194-1194 (1)   A criança não saiu do hospital junto com você porque:
# S134        1195-1195 (1)   Você fez consulta de puerpério (consulta com médico ou enfermeiro até 42 dias após o parto)?
# S135        1196-1196 (1)   Qual o motivo de não ter feito a consulta de puerpério (consulta com médico ou enfermeiro até 42 dias após o parto)?
# S136        1197-1197 (1)   Durante os primeiros três meses após o parto, você tomou medicamento contendo somente ferro ou ferro com vitaminas?
# S137        1198-1198 (1)   Por que não tomou o medicamento?
# S138        1199-1199 (1)   Na maioria das vezes, o medicamento contendo somente ferro ou ferro com vitaminas foi obtido em serviço público de saúde?
# S139        1200-1200 (1)   Após o parto, por quanto tempo tomou o medicamento contendo somente ferro ou ferro com vitaminas?
# U00204      1201-1201 (1)   O que o(a) Sr(a) usa para fazer a limpeza de sua boca Escova de dente
# U00205      1202-1202 (1)   O que o(a) Sr(a) usa para fazer a limpeza de sua boca Pasta de dente
# U00206      1203-1203 (1)   O que o(a) Sr(a) usa para fazer a limpeza de sua boca Fio dental
# U00207      1204-1204 (1)   O que o(a) Sr(a) usa para fazer a limpeza de sua boca Enxaguatório bucal (como plax, colgate, cepacol)
# U00208      1205-1205 (1)   O que o(a) Sr(a) usa para fazer a limpeza de sua boca Outros
# U00101      1206-1206 (1)   Com que frequência o(a) Sr(a) usa escova de dentes para a higiene bucal
# U00401      1207-1207 (1)   Com que frequência o(a) Sr(a) troca a sua escova de dente por uma nova
# U005        1208-1208 (1)   Em geral, como o(a) Sr(a) avalia sua saúde bucal (dentes e gengivas)
# U006        1209-1209 (1)   Que grau de dificuldade o(a) Sr(s) tem para se alimentar por causa de problemas com seus dentes ou dentadura?
# U00902      1210-1211 (2)   Qual o principal motivo que o(a) fez consultar o dentista na última vez
# U01002      1212-1212 (1)   Onde foi a última consulta odontológica
# U014        1213-1213 (1)   Como o(s) Sr(a) conseguiu a consulta odontológica:
# U02001      1214-1214 (1)   O (A) Sr (a) pagou algum valor por esta consulta odontológica (Entrevistador: Se o(a) entrevistado (a) responder que pagou, mas teve reembolso total, marque a opção 2)
# U02101      1215-1215 (1)   Esta consulta odontológica foi feita pelo SUS
# U02302      1216-1216 (1)   Lembrando-se dos seus dentes permanentes de cima, o(a) Sr(a) perdeu algum
# U02303      1217-1218 (2)   Quantos dentes permanentes de cima perdeu?
# U02402      1219-1219 (1)   Lembrando-se dos seus dentes permanentes de baixo, o(a) Sr(a) perdeu algum
# U02403      1220-1221 (2)   Quantos dentes permanentes de baixo perdeu?
# U02501      1222-1222 (1)   O(A) Sr(a) usa algum tipo de prótese dentária (dente artificial, implante, dentadura, chapa)
# Z001        1223-1223 (1)   Você já teve/tem filho(s) biológico(s)?
# Z00101      1224-1225 (2)   Quantos homens
# Z00102      1226-1227 (2)   Quantas mulheres
# Z002        1228-1229 (2)   Quantos anos você tinha quando seu primeiro filho nasceu?
# Z003        1230-1231 (2)   Qual a idade do seu filho mais novo ou único nascido vivo?
# Z004        1232-1232 (1)   Atualmente, alguma mulher está grávida de você?
# Z005        1233-1233 (1)   Na gravidez atual ou na do de seu último filho nascido vivo, você desejava ter filho naquele momento?
# Z006        1234-1234 (1)   Na gravidez atual ou na do seu último filho nascido vivo foi feito pré-natal?
# Z007        1235-1235 (1)   A maioria das consultas na gravidez atual ou na do seu último filho nascido vivo foi feita pelo SUS?
# Z008        1236-1236 (1)   Você acompanha ou acompanhou o pré-natal da gravidez atual ou da gravidez do seu último filho?
# Z009        1237-1237 (1)   Algum profissional de saúde responsável pelo pré-natal fez solicitação de exame para você?
# Z010        1238-1238 (1)   Você realizou os exames solicitados?
# Z011        1239-1239 (1)   Durante o pré-natal da gravidez atual ou da gravidez do último filho, você foi incentivado a participar de palestras, rodas de conversas, cursos, etc. sobre os cuidados com o bebê?
# Z012        1240-1240 (1)   Você foi informado por algum profissional de saúde, que realizou o pré-natal, sobre a possibilidade de participar do momento do parto?
# Z013        1241-1241 (1)   Tem filhos (as) adotivos (as)?
# Z01401      1242-1243 (2)   Quantos homens
# Z01402      1244-1245 (2)   Quantas mulheres
# V001        1246-1246 (1)   Foi assegurada a privacidade para aplicação desse módulo
# V00101      1247-1247 (1)   O questionário foi preenchido por:
# V00201      1248-1248 (1)   Nos últimos doze meses, alguém: Te ofendeu, humilhou ou ridicularizou na frente de outras pessoas?
# V00202      1249-1249 (1)   Nos últimos doze meses, alguém: Gritou com você ou te xingou?
# V00203      1250-1250 (1)   Nos últimos doze meses, alguém: Usou redes sociais ou celular para ameaçar, ofender, xingar ou expor imagens suas sem o seu consentimento?
# V00204      1251-1251 (1)   Nos últimos doze meses, alguém: Te ameaçou de ferir ou machucar alguém importante para você?
# V00205      1252-1252 (1)   Nos últimos doze meses, alguém: Destruiu alguma coisa sua de propósito?
# V003        1253-1253 (1)   Nos últimos doze meses, quantas vezes isso aconteceu com você?
# V006        1254-1255 (2)   Quem fez isso com você? (Se mais de uma pessoa, defina o pirncipal agressor)
# V007        1256-1256 (1)   Onde isso ocorreu?
# V01401      1257-1257 (1)   Nos últimos doze meses, alguém: Te deu um tapa ou uma bofetada?
# V01402      1258-1258 (1)   Nos últimos doze meses, alguém: Te empurrou, segurou com força ou jogou algo em você com a intenção de machucar?
# V01403      1259-1259 (1)   Nos últimos doze meses, alguém: Te deu um soco, chutou ou arrastou pelo cabelo?
# V01404      1260-1260 (1)   Nos últimos doze meses, alguém: Tentou ou efetivamente estrangulou, asfixiou ou te queimou de propósito?
# V01405      1261-1261 (1)   Nos últimos doze meses, alguém: Te ameaçou ou feriu com uma faca, arma de fogo ou alguma outra arma ou objeto?
# V015        1262-1262 (1)   Nos últimos doze meses, quantas vezes isso aconteceu?
# V018        1263-1264 (2)   Quem fez isso com você
# V019        1265-1265 (1)   Onde isso ocorreu?
# V02701      1266-1266 (1)   Nos últimos doze meses, alguém: tocou, manipulou, beijou ou expôs partes do seu corpo contra sua vontade
# V02702      1267-1267 (1)   Nos últimos doze meses, alguém: Te ameaçou ou forçou a ter relações sexuais ou quaisquer outros atos sexuais contra sua vontade?
# V02801      1268-1268 (1)   E alguma vez na vida, alguém: tocou, manipulou, beijou ou expôs partes do seu corpo contra sua vontade
# V02802      1269-1269 (1)   E alguma vez na vida, alguém: Te ameaçou ou forçou a ter relações sexuais ou quaisquer outros atos sexuais contra sua vontade?
# V029        1270-1270 (1)   Nos últimos doze meses, quantas vezes isso aconteceu?
# V032        1271-1272 (2)   Quem fez isso com você
# V033        1273-1273 (1)   Onde isso ocorreu?
# V034        1274-1274 (1)   Nos últimos doze meses, você deixou de realizar quaisquer de suas atividades habituais (trabalhar, realizar afazeres domésticos, ir à escola etc.) por causa desse ato
# V03501      1275-1275 (1)   Esse(s) ato(s) sexual(is) forçado(s) gerou(aram) alguma consequência para sua saúde, tais como: Hematomas, cortes, fraturas, queimaduras ou outras lesões físicas ou ferimentos?
# V03502      1276-1276 (1)   Esse(s) ato(s) sexual(is) forçado(s) gerou(aram) alguma consequência para sua saúde, tais como: Medo, tristeza, desânimo, dificuldade para dormir, ansiedade, depressão ou outras consequências psicológicas?
# V03503      1277-1277 (1)   Esse(s) ato(s) sexual(is) forçado(s) gerou(aram) alguma consequência para sua saúde, tais como: Doença sexualmente transmissível ou gravidez indesejada?
# V036        1278-1278 (1)   Por causa desta (s) consequência (s), você procurou algum atendimento de saúde
# V037        1279-1279 (1)   Por causa desta (s) consequência (s), você recebeu algum atendimento de saúde
# V038        1280-1281 (2)   Onde foi realizado este atendimento de saúde
# V039        1282-1282 (1)   Por causa desta (s) consequência (s), você precisou ser internado por 24 horas ou mais
# T001        1283-1283 (1)   O (a) Sr. (a) está com tosse há três semanas ou mais?
# T002        1284-1284 (1)   O (a) Sr (a) tem mancha com dormência ou parte da pele com dormência?
# T003        1285-1285 (1)   Algum médico já lhe deu o diagnóstico de doença de Chagas?
# T004        1286-1286 (1)   Nos últimos 12 meses, algum médico lhe deu diagnóstico de doença/infecção sexualmente transmissível?
# T005        1287-1287 (1)   Nesse diagnóstico (se houver mais de um, considere o último) de doença/infecção sexualmente transmissível, o(a) Sr(a) fez algum tipo de tratamento com prescrição médica?
# T00601      1288-1288 (1)   Nesse diagnóstico recebeu orientações? Usar regularmente preservativo
# T00602      1289-1289 (1)   Nesse diagnóstico recebeu orientações? Informar aos (às) parceiros (as) da infecção
# T00603      1290-1290 (1)   Nesse diagnóstico recebeu orientações? Fazer o teste de HIV
# T00604      1291-1291 (1)   Nesse diagnóstico recebeu orientações? Fazer o teste de sífilis
# T00605      1292-1292 (1)   Nesse diagnóstico recebeu orientações? Fazer os testes para as hepatites B e C
# T00606      1293-1293 (1)   Nesse diagnóstico recebeu orientações? Tomar vacina para hepatite B
# Y001        1294-1294 (1)   Que idade tinha quando teve relações sexuais pela primeira vez?
# Y00101      1295-1297 (3)   Idade do morador quando teve relações sexuais pela primeira vez
# Y002        1298-1298 (1)   Nos últimos doze meses teve relações sexuais?
# Y003        1299-1299 (1)   Nos últimos doze meses nas relações sexuais que teve, com que frequência usou camisinha:
# Y004        1300-1300 (1)   Nos últimos doze meses na última relação sexual que teve, foi usada camisinha masculina ou feminina?
# Y005        1301-1301 (1)   Qual o principal motivo por não ter usado camisinha?
# Y006        1302-1302 (1)   Nos últimos doze meses, alguma vez procurou algum serviço público (posto, centro de saúde, hospital público, hospital conveniado do SUS, agente comunitário de saúde) para obter camisinha masculina ou feminina?
# Y007        1303-1303 (1)   Por que não procurou algum serviço público saúde para obter camisinha masculina ou feminina?
# Y008        1304-1304 (1)   Qual é a sua orientação sexual?
# H001        1305-1305 (1)   Quando foi a última vez que o(a) sr(a) consultou com um(a) médico(a)?
# H002        1306-1306 (1)   Essa consulta foi o seu primeiro atendimento com esse(a) médico(a)?
# H003        1307-1307 (1)   Por qual motivo o(a) sr(a) precisou consultar com um(a) médico(a)
# H004        1308-1309 (2)   Onde procurou o atendimento médico por este motivo?
# H005        1310-1310 (1)   Você geralmente procura “esse(a) médico(a) quando adoece ou precisa de conselhos sobre a sua saúde?
# H006        1311-1311 (1)   “Esse(a) é o(a) médico(a) que melhor conhece você como pessoa?
# H007        1312-1312 (1)   “Esse(a) é o(a) médico(a) mais responsável por seu atendimento de saúde?
# H008        1313-1313 (1)   Quando você tem um novo problema de saúde, você vai à “esse(a) médico(a) antes de ir a outro serviço de saúde?
# H009        1314-1314 (1)   Quando o(a) “serviço de saúde” está aberto(a), você consegue aconselhamento rápido pelo telefone se precisar?
# H010        1315-1315 (1)   É difícil para você conseguir atendimento médico no(a) serviço de saúde” quando pensa que é necessário?
# H011        1316-1316 (1)   Quando você vai ao(à) serviço de saúde, é o(a) mesmo(a) médico(a) que atende você todas as vezes?
# H012        1317-1317 (1)   Você se sente à vontade contando as suas preocupações ou problemas à “esse(a) médico(a)”?
# H013        1318-1318 (1)   “Esse(a) médico(a)” sabe quais problemas são mais importantes para você?
# H014        1319-1319 (1)   Se fosse muito fácil, você mudaria do(a) “serviço de saúde” para outro serviço de saúde?
# H015        1320-1320 (1)   Você foi consultar qualquer tipo de especialista ou serviço especializado no período em que você está em acompanhamento com “esse(a) médico(a)?
# H016        1321-1321 (1)   “Esse(a) médico(a) sugeriu (indicou, encaminhou) que você fosse consultar com esse(a) especialista ou serviço especializado?
# H017        1322-1322 (1)   “Esse(a) médico(a)” escreveu alguma informação para o(a) especialista sobre o motivo dessa consulta?
# H018        1323-1323 (1)   “Esse(a) médico(a)” sabe quais foram os resultados dessa consulta?
# H019        1324-1324 (1)   “Esse(a) médico(a)” pareceu interessado(a) na qualidade do cuidado que você recebeu no(a) especialista ou serviço especializado (perguntou se você foi bem ou mal atendido(a))?
# H020        1325-1325 (1)   Se quisesse, você poderia ler (consultar) o seu prontuário médico no(a) serviço de saúde?
# H021        1326-1326 (1)   Aconselhamento para problemas de saúde mental (ex.: ansiedade, depressão)
# H022        1327-1327 (1)   Aconselhamento sobre como parar de fumar
# H023        1328-1328 (1)   Aconselhamento sobre as mudanças que acontecem com o envelhecimento (ex.: diminuição da memória, risco de cair)
# H024        1329-1329 (1)   Orientações sobre alimentação saudável, boa higiene e sono adequado (dormir suficientemente)
# H025        1330-1330 (1)   Orientações sobre exercícios físicos apropriados para você
# H026        1331-1331 (1)   Verificar e discutir os medicamentos que você está usando
# H027        1332-1332 (1)   Como prevenir quedas
# H028        1333-1333 (1)   “Esse(a) médico(a)” pergunta as suas ideias e opiniões (o que você pensa) ao planejar o tratamento e cuidado para você ou para um membro da sua família?
# H029        1334-1334 (1)   “Esse(a) médico(a)” se reuniria com membros de sua família se você achasse necessário?
# H030        1335-1335 (1)   No seu seviço de saúde são realizadas pesquisas com os pacientes para ver se os serviços estão satisfazendo (atendendo) as necessidades das pessoas
# W001        1336-1336 (1)   Antropometria aferida do morador selecionado
# W00101      1337-1341 (5)   Peso - 1ª pesagem (em kg)(3 inteiros e 1 casa decimal)
# W00102      1342-1346 (5)   Peso - 2ª pesagem (em kg)(3 inteiros e 1 casa decimal)
# W00103      1347-1351 (5)   Peso - Final (em kg)(3 inteiros e 1 casa decimal)
# W00201      1352-1356 (5)   Altura - 1ª medição (em cm)(3 inteiros e 1 casa decimal)
# W00202      1357-1361 (5)   Altura - 2ª medição (em cm)(3 inteiros e 1 casa decimal)
# W00203      1362-1366 (5)   Altura - Final (em cm)(3 inteiros e 1 casa decimal)
# V0028       1367-1380 (14)  Peso do domicílio e dos moradores sem calibração
# V0029       1381-1394 (14)  Peso do morador selecionado sem calibração
# V0030       1395-1411 (17)  Peso do morador selecionado para antropometria sem calibração
# V00281      1412-1425 (14)  Peso do domicílio e dos moradores com calibração
# V00291      1426-1439 (14)  Peso do morador selecionado com calibração
# V00301      1440-1456 (17)  Peso do morador selecionado para antropometria com calibração
# V00282      1457-1465 (9)   Projeção da população
# V00292      1466-1482 (17)  Projeção da população para moradores selecionados
# V00302      1483-1499 (17)  Projeção da população para moradores selecionados para antropometria
# V00283      1500-1502 (3)   Domínio de projeção para domicílio e moradores
# V00293      1503-1507 (5)   Domínio de projeção para morador selecionado
# V00303      1508-1509 (2)   Domínio de projeção para morador selecionado para antropometria
# VDC001      1510-1511 (2)   Número de componentes do domicílio (exclusive as pessoas cuja condição na família era pensionista, empregado doméstico ou parente do empregado doméstico)
# VDC003      1512-1513 (2)   Total de moradores com 15 anos ou mais
# VDD004A     1514-1514 (1)   Nível de instrução mais elevado alcançado (pessoas de 5 anos ou mais de idade) padronizado para o Ensino Fundamental -  SISTEMA DE 9 ANOS
# VDE001      1515-1515 (1)   Condição em relação à força de trabalho na semana de referência para pessoas de 14 anos ou mais de idade
# VDE002      1516-1516 (1)   Condição de ocupação na semana de referência para pessoas de 14 anos ou mais de idade
# VDE014      1517-1518 (2)   Grupamentos de atividade do trabalho principal da semana de referência para pessoas de 14 anos ou mais de idade
# VDF002      1519-1526 (8)   Rendimento domiciliar (exclusive o rendimento das pessoas cuja condição na unidade domiciliar era pensionista, empregado doméstico ou parente do empregado doméstico)
# VDF003      1527-1534 (8)   Rendimento domiciliar per capita(exclusive o rendimento das pessoas cuja condição na unidade domiciliar era pensionista, empregado doméstico ou parente do empregado doméstico)
# VDF004      1535-1535 (1)   Faixa de rendimento domiciliar per capita (exclusive o rendimento das pessoas cuja condição na unidade domiciliar era pensionista, empregado doméstico ou parente do empregado doméstico)
# VDL001      1536-1537 (2)   Idade em meses das crianças nascidas no período de referência do Módulo L
# VDM001      1538-1538 (1)   Faixa de tempo gasto por dia no deslocamento casa-trabalho pelas pessoas ocupadas que se deslocavam para o trabalho
# VDP001      1539-1539 (1)   Tipo de cigarro industrializado comprado
# VDR001      1540-1540 (1)   Método contraceptivo mais eficaz que faz uso
# VDDATA      1541-1548 (8)   Data de geração do arquivo de microdados. Data ordenada na forma: ano (4 algarismos), mês (2) e dia (2) -  AAAAMMDD
