library('RSQLite')

gumtree_warszawa_pokoje <- data.frame(opis = "", 
																			cena = "",
																			wielkosc = "",
																			telephone = "", 
																			stringsAsFactors = FALSE)

conn <- dbConnect( dbDriver( "SQLite" ), "przyklad.db" )

dbWriteTable(conn, name = "gumtree_warszawa_pokoje", gumtree_warszawa_pokoje, overwrite = TRUE, row.names = FALSE)

dbListTables(conn)

dbListFields(conn, "gumtree_warszawa_pokoje")

schakuj() -> przyklad_link

dbGetQuery(conn, 
						paste0("INSERT INTO gumtree_warszawa_pokoje (opis, cena, wielkosc, telephone) values ('", przyklad_link$opis, "', '", przyklad_link$cena, "', '", przyklad_link$wielkosc, "', '", przyklad_link$telephone, "')")
)


dbGetQuery(conn, 'select * from gumtree_warszawa_pokoje') -> res
