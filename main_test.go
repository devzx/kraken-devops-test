package main

import (
	"bytes"
	"os"
	"testing"

	"github.com/anaskhan96/soup"
)

func Test_countryList(t *testing.T) {
	b, err := os.ReadFile("testdata/england_covid_entry.html")
	if err != nil {
		t.Fatal(err)
	}

	doc := soup.HTMLParse(string(b))
	got := &bytes.Buffer{}
	want, err := os.ReadFile("testdata/want.txt")
	if err != nil {
		t.Fatal(err)
	}
	countryLists := newCountryListsFromHTML(doc)
	for _, cl := range countryLists {
		cl.printOut(got)
	}
	if n := bytes.Compare(got.Bytes(), want); n != 0 {
		t.Errorf("printOut() got: %s != want: %s", got, want)
	}
}
