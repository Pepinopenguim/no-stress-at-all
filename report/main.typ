#import "unb-templante.typ": *


// ❱❱❱ Dados para os pretextuais e bibliografia

#show: relatório.with(
    título: "Modelagem Numérica da Punção em Lajes de Concreto Armado usando Elementos Finitos",
    subtítulo: "Seminário de mestrado em estruturas e construção civil",
    tipo: "TCC", // "Tese", "Dissertação", "TCC", "Seminário"
    programa: "Programa de Pós-Graduação em Estruturas e Construção Civil",
    departamento: "Departamento de Engenharia Civil e Ambiental",
    faculdade: "Faculdade de Tecnologia",
    autor: "Vítor Luís Costa Azevedo",
    orientador: "Raul Durand",
    coorientador: none,
    data: datetime(day:1, month:1, year:2025),
    bibliografia: "ref.bib",
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