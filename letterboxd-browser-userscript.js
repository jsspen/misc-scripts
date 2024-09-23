// ==UserScript==
// @name         Letterboxd Ratings
// @version      1.0
// @description  Add Letterboxd ratings box to page
//               Borrowing heavily from work by Chameleon, LuckyLuciano, and Helmut
// @grant        GM_xmlhttpRequest
// ==/UserScript==

(function () {
  ("use strict");
  if (window.location.href.indexOf("details.php?id=") != -1) {
    // once we make sure we're on the right page
    // we kick things off
    var letterboxdLink = getLink();
    if (letterboxdLink) {
      fetchHistogram(letterboxdLink);
    }

    // takes the query from the addLink function
    // in this case: "//td[@class='heading']"
    // and returns an array of each occurance
    function xpath(query) {
      return document.evaluate(
        query,
        document.body,
        null,
        XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE,
        null
      );
    }

    // Finds the imdb link on the page using xpath and a loop
    // to search for the "Internet Link" section that contains the link
    // returns a call to getImdb and passes it the link which gets processed
    // from an imdb link to a letterboxd link and returns it to the very
    // beginning, meaning the value of letterboxdLink and then continues
    // down to line 53 to make a place for it
    function getLink() {
      var st = xpath("//td[@class='heading']");
      var i = 0;
      while (
        i < st.snapshotLength &&
        st.snapshotItem(i).innerHTML != "Internet Link"
      )
        i++;
      if (i < st.snapshotLength) {
        var node = st.snapshotItem(i).nextSibling;
        var link = node.firstChild.href.split("/title/tt")[1];
        return "https://letterboxd.com/imdb/tt" + link;
      }
    }

    // Create a new row for Letterboxd
    // this is where the actual iframe item should be built
    // right now it's just dropping the link
    //   var letterboxdRow = document.createElement("tr");
    //   letterboxdRow.innerHTML = `
    //         <td class="heading" valign="top" align="right">Letterboxd</td>
    //         <td valign="top" align="left" colspan="2">
    //           <a href="${letterboxdLink}" target="_blank">View on Letterboxd</a>
    //         </td>
    //       `;

    // Get the URL for the histogram page
    // the original URL /imdb/id is transformed to /film/title-info when accessed
    // and that form is needed for the rating-histogram URL
    function fetchHistogram(url) {
      var histogramURL;
      var histogramHTML;
      GM_xmlhttpRequest({
        method: "GET",
        url: url,
        onload: function (response) {
          histogramURL =
            "https://letterboxd.com/csi" +
            response.finalUrl.split("https://letterboxd.com")[1] +
            "rating-histogram/";
          GM_xmlhttpRequest({
            method: "GET",
            url: histogramURL,
            onload: function (response) {
              histogramHTML = response.responseText;
              buildRow(histogramHTML);
            },
            onerror: function (error) {
              console.error("Error:", error);
            },
          });
        },
        onerror: function (error) {
          console.error("Error:", error);
        },
      });
    }

    function buildRow(histogramHTML) {
      console.log(histogramHTML);
      var tr = document.createElement("tr");
      var td1 = document.createElement("td");
      td1.setAttribute("class", "heading");
      td1.setAttribute("valign", "top");
      td1.setAttribute("align", "right");
      td1.innerText = "Letterboxd";
      tr.appendChild(td1);
      var td2 = document.createElement("td");
      td2.setAttribute("valign", "top");
      td2.setAttribute("align", "left");
      td2.setAttribute("colspan", "2");
      tr.appendChild(td2);
      var div1 = document.createElement("div");
      var div2 = document.createElement("iframe");
      // size set with height to match the mediainfo box above, width relative to increase in height as based on original box size from OG script
      div2.setAttribute(
        "style",
        "background:#14181c; border:none; width:230px; height:95px; padding:10px;"
      );
      div1.appendChild(div2);
      td2.appendChild(div1);
      div2.src =
        "data:text/html;charset=utf-8,<html><head><link href='https://s.ltrbxd.com/static/css/main.min.a04afb87.css' rel='stylesheet' type='text/css'><style>.section { padding:0 !important; }</style></head><body>" +
        histogramHTML.replace(/href="/g, 'href="https://letterboxd.com') +
        "</body></html>";
      // var modifiedDiv2 = modifyLinks(div2.src);
      // div2.src = modifiedDiv2
      div2.src = modifyLinks(div2.src);
      insertRow(tr);
    }

    function modifyLinks(htmlFragment) {
      // Create a temporary container element
      let container = document.createElement("div");

      // Set the container's innerHTML to the HTML fragment
      container.innerHTML = htmlFragment;

      // Select all anchor tags within this fragment
      let anchors = container.querySelectorAll("a");

      // Add target="_blank" to each anchor
      anchors.forEach((anchor) => {
        anchor.setAttribute("target", "_blank");
      });

      // Return the modified innerHTML, which is just the fragment
      return container.innerHTML;
    }

    function insertRow(builtRow) {
      var rows = document.querySelectorAll("tr");
      var peersRow;
      // Find all 'tr' elements
      // Iterate over each row to find one that contains the desired text
      // (could this be done usingn the xpath function as used before with finding the imdb column?)
      rows.forEach(function (row) {
        var cell = row.querySelector("td.heading");
        if (cell && cell.textContent.includes("Peers")) {
          peersRow = row;
        }
      });

      // once the penultimate row (the peers row) has been found
      // insert the Letterboxd row after it
      peersRow.parentNode.insertBefore(builtRow, peersRow.nextSibling);
    }
  }
})();
