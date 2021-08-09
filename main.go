package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/anaskhan96/soup"
)

// englandCovidEntryRequirementsUrl is UK Government site that shows the current rules for entering England
const englandCovidEntryRequirementsUrl = "https://www.gov.uk/guidance/red-amber-and-green-list-rules-for-entering-england"

func main() {
	resp, err := http.Get(englandCovidEntryRequirementsUrl)
	if err != nil {
		log.Fatal(err)
	}
	b, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	doc := soup.HTMLParse(string(b))
	countryLists := newCountryListsFromHTML(doc)
	for _, cl := range countryLists {
		cl.printOut(os.Stdout)
	}
}

// countryList represents a list of either red, amber or green countries
type countryList struct {
	// Red list/ Amber list/ Green list
	listType  string
	countries []string
}

func (cl countryList) printOut(out io.Writer) {
	fmt.Fprintln(out, cl.listType)
	for _, c := range cl.countries {
		fmt.Fprintf(out, "\t%s\n", c)
	}
}

func newCountryListsFromHTML(doc soup.Root) []countryList {
	var countryLists []countryList
	tables := doc.Find("div", "class", "govspeak").FindAll("table")
	for _, table := range tables {
		inner := table.Find("th", "scope", "col")
		cl := countryList{
			listType: inner.Text(),
		}
		countries := table.FindAll("th", "scope", "row")
		for _, country := range countries {
			cl.countries = append(cl.countries, country.Text())
		}
		countryLists = append(countryLists, cl)
	}

	return countryLists
}
