package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/", defaultRoute)
	e.Start(":1111")
}

func defaultRoute(c echo.Context) error {
	data := getData()
	return c.JSON(http.StatusOK, data)
}

func getData() map[string]interface{} {

	r, err := http.Get("http://pokeapi.co/api/v2/pokedex/kanto/")
	if err != nil {
		log.Fatal(err)
	}

	responseData, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}

	m := make(map[string]interface{})
	if err := json.Unmarshal(responseData, &m); err != nil {
		log.Fatal(err)
	}
	return m
}
