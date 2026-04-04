.pragma library

Qt.include("http.js")

const apiUrl = "https://api.tfl.gov.uk";

const colors = {
    "Bakerloo":             "#B26313",
    "Central":              "#DC241F",
    "Circle":               "#FFD329",
    "District":             "#007D32",
    "Elizabeth":            "#6950A1",
    "Hammersmith & City":   "#F4A9BE",
    "Jubilee":              "#A1A5A7",
    "Metropolitan":         "#9B0058",
    "Northern":              "#000000",
    "Piccadilly":           "#0019A8",
    "Victoria":             "#0098D8",
    "Waterloo & City":      "#93CEBA",
    "DLR":                  "#00AFAD",
    "Overground":           "#EF7B10",
    "Lioness":              "#FFA600",
    "Mildmay":              "#006FE6",
    "Windrush":             "#DC241F",
    "Weaver":               "#9B0058",
    "Suffragette":          "#18A95D",
    "Liberty":              "#61686B"
}

const OK = 200;
const MODE_TUBE = "tube";
const MODE_OVERGROUND = "overground";

function getColorForLine(name) {

    if (name in colors) {
        return colors[name];
    }

    return "";
}

function getLinesStatus(mode, callback) {
    httpGET(`${apiUrl}/Line/mode/${mode}/Status`, function(response) {
        var allLinesStatus = []

        if (response.status === 200) {
            var data = JSON.parse(response.content);

            for (var i = 0; i < data.length; i++) {
                var name = data[i]["name"];
                var color = getColorForLine(name);
                var status = "Unknown";
                var severity = 0;
                var reason = "";

                const lineStatuses = data[i]["lineStatuses"]

                if (lineStatuses.length > 0) {
                    status = lineStatuses[0]["statusSeverityDescription"];
                    severity = lineStatuses[0]["statusSeverity"];
                    reason = lineStatuses[0]["reason"];

                    if (reason === undefined) {
                        reason = status;
                    }
                }

                allLinesStatus.push({
                    "mode": mode,
                    "name": name,
                    "color": color,
                    "status": status,
                    "severity": severity,
                    "reason": reason
                });
            }
        }

        callback(response.status, allLinesStatus);
    });
}

function getAllLinesStatus(callback) {
    getLinesStatus(MODE_TUBE, function(status, data) {
        if (status === OK) {
            getLinesStatus(MODE_OVERGROUND, function(status, overgroundData) {
                data = data.concat(overgroundData);
                callback(status, data);
            });
        } else {
            callback(status, data);
        }
    });
}
