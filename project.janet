(declare-project
  :name "ogp2rss"
  :description ```basic rss feed from open graph properties ```
  :dependencies [{:url "https://github.com/janet-lang/spork.git"
                  :tag "v1.2.0"}]
  :version "0.0.0")

(declare-executable
  :name "ogp2rss"
  :entry "ogp2rss/init.janet")
