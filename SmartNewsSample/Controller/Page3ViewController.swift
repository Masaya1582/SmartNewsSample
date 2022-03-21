

import UIKit
import SegementSlide

class Page3ViewController: UITableViewController, SegementSlideContentScrollViewDelegate, XMLParserDelegate {
    
    private var parser = XMLParser()
    private var currentElementName: String!
    private var newsItems  = [NewsItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        let newsItem = self.newsItems[indexPath.row]
        cell.textLabel?.text = newsItem.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 3
        cell.detailTextLabel?.text = newsItem.url
        cell.detailTextLabel?.textColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = WebViewController()
        webViewController.modalTransitionStyle = .crossDissolve
        let newsItem = newsItems[indexPath.row]
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        present(webViewController, animated: true, completion: nil)
    }
    
    @objc var scrollView: UIScrollView {
        return tableView
    }
    
    private func initTableView() {
        tableView.backgroundColor = .clear
        let image = UIImage(named: "2")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        let urlString = "https://news.yahoo.co.jp/rss/topics/top-picks.xml"
        let url: URL = URL(string: urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        if elementName == "item" {
            self.newsItems.append(NewsItems())
        }else {
            currentElementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.newsItems.count > 0 {
            let lastItem = self.newsItems[self.newsItems.count - 1]
            switch self.currentElementName {
            case "title":
                lastItem.title = string
            case "link":
                lastItem.url = string
            case "pubDate":
                lastItem.pubDate = string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentElementName = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
}
