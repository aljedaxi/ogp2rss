(import spork/json)
(use spork/htmlgen)

(defn itemify [{:ogTitle title
                :articleTag oneTagWhat
                :articlePublishedTime pubDate}]
  (def link (string/format "https://dasein-online.ca/articles/%s/index.html" (string/replace-all " " "-" title)))
  [:item
     [:title title]
     [:link link]
     [:guid link]
     [:pubDate pubDate]
     [:category oneTagWhat]])

(defn channelify [items]
  [:rss {:version "2.0"}
     [:channel
        [:title "dasein online"]
        [:link "http://dasein-online.ca"]
        [:description "who knows"]
        [:copywrite "peer production license"]
        [:language "en-ca"]
        [:generator "ogp2rss"]
        (map |(-> $ string/trim (json/decode true) itemify) items)]])

(defn main
  [& args]
  (->> stdin
       file/lines
       channelify
       html
       (string/format "<?xml version=\"1.0\" encoding=\"UTF-8\"?>%s")
       prin))
