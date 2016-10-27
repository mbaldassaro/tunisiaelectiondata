# Site Architecture 

[Tunisia Election Data](http://fwelections.github.com/databrowser/en/projects/) is built on a framework called [Jekyll](https://github.com/mojombo/jekyll). Jekyll is a relatively light weight site generator that scales well with additional content. If you have not worked with it before, do not worry as it is very straight forward.

### High level overview of Jekyll
Jekyll works by populating the _posts folder with html files. These HTML file follow a standard format. In the head area we describe parameters on how the page will be rendered. We specify things like the type of page it is, whether there is a legend on the map ID, the language, etc. This information is found between the two sets of dashes --- ---. Below that is what referred to as 'content' we choose to render depending on the page.

If you wanted to add an additional map page, it would be as simple as copy and pasting one of the current map pages and filling in the information parameters: title, subtitle, map id etc. It will then be added in all the place automatically - the projects page and the link from the projects page to its actual page should work as well.

To get started with Jekyll, first install it. The best way is to install it via ruby gem install:

```
$ gem install jekyll
```

Next you will want to start up a local instance of the website. Do this by navigating to the folder where the website lives and write the following command into terminal:

```
$ jekyll
```

When you do this, Jekyll process all the files and creates a _site folder- this is your generated site. Open your browser at the following location: localhost:8000/tunisia-election-data/ . Your site should be there. You can specify the url after 8000/tunisia... by editing the _config.yml file.

As long as the server is running in terminal (stop it by pressing control + c) the site should reflect changes made in your editor. Sometimes if you are dealing with large files, it can take a couple refreshes for the changes to be reflected in the browser. If you are not seeing any changes, try deleting the _site folder and restarting jekyll.

Jekyll also makes it easy to update headers, footers and the general layout across all pages. This is done by editing a file in the _layouts page. In this folder there is a project-page.html, maps.html and default.html. The maps.html has logic for rendering the maps and also the structure of the page. CSS for anything related to maps is found in the maps.css file while anything related to site structure is found in site.css

### Language Tooltips

Each map is designed to work with 3 different languages. We did this by creating a tooltip in tilemill that had the same value three times- 1 for each language:

![](http://i.imgur.com/Wn1jkLI.png)

Each section has a class associated with it: lang-en, lang-ar and lang-fr. Depending on the language of the page, we apply display:none to the languages we do not want to show. This makes it easy to render once and have 3 languages. For example on on Arabic map page the following code would be included:
```
.lang-en,
.lang-fr{
   display:none;
}
```
This makes it so only the Arabic translation shows on the map tooltip.

### Hosting the site
We like hosting websites on github. Github makes it super simple to deploy and makes changes to Jekyll websites. If you would like to read up on how this works, follow along [here](https://help.github.com/categories/20/articles). If you would like to host it on your current site, you can simple upload the _site folder to your server and it should just work.


### Additional Information

- [Jekyll documentation](https://github.com/mojombo/jekyll/wiki)
- [Liquid documentation](https://github.com/shopify/liquid/wiki/liquid-for-designers)
- [GitHub pages documentation](https://help.github.com/categories/20/articles)
- [MapBox Map Sites documentation](https://github.com/mapbox/map-site/blob/693793b57a2e1bdc03a133015961fb85639a628a/readme.md)

# Data Management and Maps

A powerful, combination of [Postgres](http://www.postgresql.org/about/) and [PostGIS](postgis.org/docs/) powers all maps on [Tunisia Election Data](http://fwelections.github.com/databrowser/en/projects/). Postgres is a very powerful open source relational database that you can access via your command line and is very well documented. For this tutorial, however, we will interact with Postgres from the command line. PostGIS is the geospatial extension that allows for storage and manuipulation of geographic data in Postgres. Together, Postgres + PostGIS allow for flexible data manipulation and highly refined cartography.

__IMPORTANT__: Before attempting to recreate the maps in this project be sure to read about working with [PostGIS and TileMill](http://mapbox.com/tilemill/docs/guides/postgis-work/). Here you will find relevant links for downloading and installing Postgres and PosGIS. You need to learn how to [create a new postgres database + install PostGIS](http://mapbox.com/tilemill/docs/guides/postgis-work/#creating_a_simple_postgis_database) before proceeding any further. 

This tutorial assumes you have set up a postgres databse called `tunisia` with PostGIS >=2.0 installed. To create this database and install PostGIS run

<pre>
createdb tunisia
psql -d tunisia -c "create extension postgis"
</pre>

Also be sure to have [installed TileMill](http://mapbox.com/tilemill/docs/mac-install/) and taken the [crash course](http://mapbox.com/tilemill/docs/crashcourse/introduction/).

### Importing geographic data to PostGIS. 

Importing geographic data into PostGIS from shapefiles is made relatively easy with the [shp2pgsql loader](http://postgis.net/docs/manual-2.0/using_postgis_dbmanagement.html#shp2pgsql_usage). To import the [delegtion shapefiles](https://github.com/fwelections/tunisia-election-data/tree/master/shapes) to a table called `delegations`, run the following command:

<pre>
shp2pgsql -D -s 4326 path-to/shapes/delegations.shp delegations | psql -d tunisia
</pre>

### Data processing for making maps

For detailed instructions on how we created each of the four maps on [Tunisia Election Data](http://fwelections.github.com/databrowser/en/projects/), see each maps documentation.

- Actively Registered vs. Eligible Voters
- Political Party Results
- Votes invalidated at counting
- Votes that did not count