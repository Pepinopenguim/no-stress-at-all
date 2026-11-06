using Serendip

another_chart = Chart(
    xlabel = "`u_z` [mm]",
    ylabel = "`F_y` [kN]",
)

table1 = DataTable("RS_SYM/logger_load-20.dat") 
table2 = DataTable("RS_SYM/logger_load-70.dat") 

global_fz = (table1.fz .+ table2.fz) * 4

table_ensaio1 = DataTable("RS_SYM/logger4.dat")
table_ensaio2 = DataTable("RS_SYM/logger8.dat")

global_uz = (table_ensaio1.uz + table_ensaio2.uz) / 2



add_line(
    another_chart,
    -global_uz * 1e3,
    -global_fz,
    mark  = :circle,
)

# read actual data from experiment
using JSON


data = JSON.parse(read("dat/wp_disp.json", String))



exp_uz = parse.(Float64, [row["disp_m"] for row in data])
exp_fz = parse.(Float64, [row["f_N"] for row in data])

add_line(
    another_chart,
    exp_uz * 1e3,
    exp_fz * 1e-3,
    mark  = :none,
)

save(another_chart, "test2.pdf")