#import "unb-templante.typ": *


// ❱❱❱ Dados para os pretextuais e bibliografia

#show: relatório.with(
    título: "Título do trabalho",
    subtítulo: "Seminário de mestrado em estruturas e construção civil",
    tipo: "Seminário", // "Tese", "Dissertação", "TCC", "Seminário"
    programa: "Programa de Pós-Graduação em Estruturas e Construção Civil",
    departamento: "Departamento de Engenharia Civil e Ambiental",
    faculdade: "Faculdade de Tecnologia",
    autor: "Altair Pena",
    orientador: "Horácio Faro de Gusmão",
    coorientador: "Corina Duarte",
    data: datetime(day:1, month:1, year:2025),
    bibliografia: "referências.bib",
    estilo: "abnt.csl",
)

// ❱❱❱ Arquivos de conteúdo

#include "conteúdo/introdução.typ"
#include "conteúdo/revisão.typ"
#include "conteúdo/metodologia.typ"
#include "conteúdo/redação.typ"
#include "conteúdo/análise.typ"
#include "conteúdo/conclusões.typ"
#include "conteúdo/cronograma.typ"

// ❱❱❱ Apêndices e anexos

#show: adendos
#include("conteúdo/apendices.typ")

// A bibliografia é gerada a partir dos arquivos `.bib` e `.csl` especificados na função `relatório`.