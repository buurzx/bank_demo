postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root bank15

dropdb:
	docker exec -it postgres15 dropdb bank15

migrateup:
	docker run -v ${PWD}/db/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database "postgresql://root:secret@localhost:5432/bank15?sslmode=disable" -verbose up
	
migratedown:
	docker run -v ${PWD}/db/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database "postgresql://root:secret@localhost:5432/bank15?sslmode=disable" -verbose down -all

sqlc-generate:
	docker run --rm -v ${PWD}:/src -w /src kjconroy/sqlc generate

.PHONY: createdb, dropdb, postgres, migratedown, migrateup, sqlc-generate
