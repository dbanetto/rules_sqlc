package main

import (
	"fmt"
	"github.com/dbanetto/rules_sqlc/e2e/smoke/go-sqlite/db"
)

func main() {
	author := db.Author{}

	fmt.Printf("%v", author)
}
