# Client-side script for querying data from partsregistry.org. queryService posts to our server,
# where there is another service that will make the actual request to partsregistry.org.
# This is because making a cross-domain request from the client side throws an error.. but seems to work
# from the node server.

brickUrl = 'api/v1/brick/'

# a map of form ids to search URLS
searches =
    '#form-text-search': '/api/v1/search/text'
    '#form-thousand-search': '/api/v1/search/thousand'
    '#form-subpart-search': '/api/v1/search/subparts'
    '#form-superpart-search': '/api/v1/search/superparts'

# Attach event handlers
Bricklayer.HomeView.afterRender = ->
    for searchId, url of searches
        # this is a closure around url.
        $(searchId).submit do (searchId, url) ->
            (e) ->
                e.preventDefault()
                Bricklayer.search url, $(searchId + " :text").val()
Bricklayer.HomeView.render {}

Bricklayer.BioBrick =
class BioBrick
    constructor: (xml) ->
        @xml = $($.parseXML xml)
        @name          = @getContent "part_name"
        @description   = @getContent "part_short_desc"
        @type          = @getContent("part_type").toLowerCase()
        @releaseStatus = @getContent "release_status"
        @partResults   = @getContent "part_results"
        @partUrl       = @getContent "part_url"
        @rating        = @getContent "part_rating"
        @dateEntered   = @getContent "part_entered"
        @author        = @getContent "part_author"
        @sequence      = @getContent "seq_data"
        @availablility = @getContent "sample_status"

        @length = @sequence.length

        @compatibility = {}
        for RFC in Bricklayer.RFCs
            @compatibility[RFC] = if Bricklayer.RFCService[RFC].isCompatible @sequence then 'yes' else 'no'

    getContent: (tagName) ->
        @xml.find(tagName).contents()[0]?.data

    getContents: (tagName) ->
        content.data for content in @xml.find(tagName).contents()

Bricklayer.lastSearchTerm = "" # keep track of the last search for displaying purposes

Bricklayer.search = (url, searchTerms) ->
    Bricklayer.lastSearchTerm = searchTerms
    console.log "Doing search for #{searchTerms}!"
    $.ajax
        type: "GET"
        url: url
        data:
            searchTerms: searchTerms
        success: (data) ->
            # The data here is an array of biobrick names
            console.log "Parts list recieved from server\n #{data}.\n Displaying..."
            displayBricks data
        error: (error) ->
            console.log error

# Step 1: Start rendering of a table
# Step 2: Fetch full information for each brick, one by one
displayBricks = (brickList) ->
    bricks = []
    Bricklayer.ResultsView.render {
        searchTerm: "'" + Bricklayer.lastSearchTerm + "'" # ugly way to get quotes to show up
        numResults: brickList.length
    }
    for brick in brickList
        $.ajax
            type: "GET"
            url: brickUrl + brick
            success: do (brick) ->
                (data) ->
                    brick = new BioBrick data
                    brick.inBin = (Bricklayer.bin.indexOf(brick.name) != -1)
                    BrickRowResultView = new Bricklayer.AppendView '#results', '#templateResultsRow'
                    BrickRowResultView.afterRender = ->
                        # attach click handler for dropdown
                        $('a.toggle-' + brick.name).click (e) ->
                            e.preventDefault()
                            target = $(e.currentTarget)
                            part = target.parents("tr").data "part"
                            extended = $('tr.toggle-' + brick.name)
                            icon = target.find ".resultIcon"
                            if extended.css("display") is "none"
                                extended.show 300
                                icon.toggleClass("icon-right-open").toggleClass "icon-down-open"
                            else
                                extended.hide()
                                icon.toggleClass("icon-right-open").toggleClass "icon-down-open"

                    BrickRowResultView.render brick
                    bricks.push brick
            error: (error) ->
                console.log error
