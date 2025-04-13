/* L' analisi è svolta con focus all' id_cliente, che infine costituirà la chiave per tutte le join che servono per costruire la tabella denormalizzata contenente tutti gli indicatori. */

/* calcolo eta */
create temporary table eta as
select id_cliente, date_format(from_days((to_days(current_date())-to_days(data_nascita))), '%y') as eta
from cliente;

 /* numero di transazioni in uscita */ 
create temporary table transazioni_uscita as 
select cliente.id_cliente, count(case when transazioni.id_tipo_trans >='3' then transazioni.id_conto end) as transazioni_uscita
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* numero di transazioni in entrata */ 
create temporary table transazioni_entrata as 
select cliente.id_cliente, count(case when transazioni.id_tipo_trans <='2' then transazioni.id_conto end) as transazioni_entrata
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* importo uscite */ 
create temporary table totale_uscite as 
select cliente.id_cliente, round(sum(case when transazioni.id_tipo_trans >='3' then transazioni.importo else 0 end),2) as totale_uscite
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* importo entrata */ 
create temporary table totale_entrate as 
select cliente.id_cliente, round(sum(case when transazioni.id_tipo_trans <='2' then transazioni.importo else 0 end),2) as totale_entrate
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* numero totale conti posseduti */
create temporary table tot_conti as 
select cliente.id_cliente, count(conto.id_conto) as tot_conti
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.tipo_conto on conto.id_tipo_conto=tipo_conto.id_tipo_conto
group by cliente.id_cliente;

/* numero di conti posseduti per tipologia */
create temporary table n_conti as 
select cliente.id_cliente,
count(case when conto.id_tipo_conto=0 then conto.id_cliente else null end) as conti_base,
count(case when conto.id_tipo_conto=1 then conto.id_cliente else null end) as conti_business,
count(case when conto.id_tipo_conto=2 then conto.id_cliente else null end) as conti_privati,
count(case when conto.id_tipo_conto=3 then conto.id_cliente else null end) as conti_famiglie
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
group by cliente.id_cliente;

/* numero di transazioni in uscita per tipologia di conto. */
create temporary table n_transazioni_uscita_per_TipoConto as 
select cliente.id_cliente, 
count(case when conto.id_tipo_conto = 0 and transazioni.id_tipo_trans >=3 then conto.id_tipo_conto end) as transazioni_uscita_ContoBase,
count(case when conto.id_tipo_conto = 1 and transazioni.id_tipo_trans >=3 then conto.id_tipo_conto end) as transazioni_uscita_ContoBusiness,
count(case when conto.id_tipo_conto = 2 and transazioni.id_tipo_trans >=3 then conto.id_tipo_conto end) as transazioni_uscita_ContoPrivati,
count(case when conto.id_tipo_conto = 3 and transazioni.id_tipo_trans >=3 then conto.id_tipo_conto end) as transazioni_uscita_ContoFamiglie
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* numero di transazioni in entrata per tipologia di conto. */
create temporary table n_transazioni_entrata_per_TipoConto as 
select cliente.id_cliente, 
count(case when conto.id_tipo_conto = 0 and transazioni.id_tipo_trans <=2 then conto.id_tipo_conto end) as transazioni_entrata_ContoBase,
count(case when conto.id_tipo_conto = 1 and transazioni.id_tipo_trans <=2 then conto.id_tipo_conto end) as transazioni_entrata_ContoBusiness,
count(case when conto.id_tipo_conto = 2 and transazioni.id_tipo_trans <=2 then conto.id_tipo_conto end) as transazioni_entrata_ContoPrivati,
count(case when conto.id_tipo_conto = 3 and transazioni.id_tipo_trans <=2  then conto.id_tipo_conto end) as transazioni_entrata_ContoFamiglie
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* importo transato in uscita per tipologia di conto */
create temporary table totale_uscite_conti as 
select cliente.id_cliente,
round(sum(case when conto.id_tipo_conto = 0 and transazioni.id_tipo_trans >=3 then transazioni.importo else 0 end),2) as totale_uscite_ContoBase,
round(sum(case when conto.id_tipo_conto = 1 and transazioni.id_tipo_trans >=3 then transazioni.importo else 0 end),2) as totale_uscite_ContoBusiness,
round(sum(case when conto.id_tipo_conto = 2 and transazioni.id_tipo_trans >=3 then transazioni.importo else 0 end),2) as totale_uscite_ContoPrivati,
round(sum(case when conto.id_tipo_conto = 3 and transazioni.id_tipo_trans >=3 then transazioni.importo else 0 end),2) as totale_uscite_ContoFamiglie
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* importo transato in entrata per tipologia di conto. */
create temporary table totale_entrate_conti as 
select cliente.id_cliente,
round(sum(case when conto.id_tipo_conto = 0 and transazioni.id_tipo_trans <= 2 then transazioni.importo else 0 end),2) as totale_entrate_ContoBase,
round(sum(case when conto.id_tipo_conto = 1 and transazioni.id_tipo_trans <= 2 then transazioni.importo else 0 end),2) as totale_entrate_ContoBusiness,
round(sum(case when conto.id_tipo_conto = 2 and transazioni.id_tipo_trans <= 2 then transazioni.importo else 0 end),2) as totale_entrate_ContoPrivati,
round(sum(case when conto.id_tipo_conto = 3 and transazioni.id_tipo_trans <= 2 then transazioni.importo else 0 end),2) as totale_entrate_ContoFamiglie
from banca.cliente
left join banca.conto on cliente.id_cliente=conto.id_cliente
left join banca.transazioni on conto.id_conto=transazioni.id_conto
group by cliente.id_cliente;

/* creazione tabella denormalizzata con tutti gli indicatori */
create temporary table tab_aggregate as 
select eta.id_cliente, eta, transazioni_uscita, transazioni_entrata, totale_uscite, totale_entrate, tot_conti,conti_base, conti_business, conti_privati, conti_famiglie, transazioni_uscita_ContoBase, transazioni_uscita_ContoBusiness,transazioni_uscita_ContoPrivati,transazioni_uscita_ContoFamiglie, transazioni_entrata_ContoBase,transazioni_entrata_ContoBusiness, transazioni_entrata_ContoPrivati, transazioni_entrata_ContoFamiglie, totale_uscite_ContoBase, totale_uscite_ContoBusiness, totale_uscite_ContoPrivati, totale_uscite_ContoFamiglie, totale_entrate_ContoBase, totale_entrate_ContoBusiness, totale_entrate_ContoPrivati, totale_entrate_ContoFamiglie
from eta 
left join transazioni_uscita on eta.id_cliente=transazioni_uscita.id_cliente
left join transazioni_entrata on eta.id_cliente=transazioni_entrata.id_cliente
left join totale_uscite on eta.id_cliente=totale_uscite.id_cliente
left join totale_entrate on eta.id_cliente=totale_entrate.id_cliente
left join tot_conti on eta.id_cliente=tot_conti.id_cliente
left join n_conti on eta.id_cliente=n_conti.id_cliente
left join n_transazioni_uscita_per_TipoConto on eta.id_cliente=n_transazioni_uscita_per_TipoConto.id_cliente
left join n_transazioni_entrata_per_TipoConto on eta.id_cliente=n_transazioni_entrata_per_TipoConto.id_cliente
left join totale_uscite_conti on eta.id_cliente=totale_uscite_conti.id_cliente
left join totale_entrate_conti on eta.id_cliente=totale_entrate_conti.id_cliente;
select * from tab_aggregate;