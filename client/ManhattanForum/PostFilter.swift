//
//  PostFilter.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/26/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

class PostFilter {
    var neighborhoods: [String]?
    var sublocalities: [String]?
    var localities: [String]?
    var negated: Bool = false
    
    init(neighborhoods: [String]?, sublocalities: [String]?, localities: [String]?) {
        self.neighborhoods = neighborhoods
        self.sublocalities = sublocalities
        self.localities = localities
    }
    
    init(neighborhoods: [String]?, sublocalities: [String]?, localities: [String]?, negated: Bool) {
        self.neighborhoods = neighborhoods
        self.sublocalities = sublocalities
        self.localities = localities
        self.negated = negated
    }
    
    class func empty() -> PostFilter {
        return PostFilter(neighborhoods: nil, sublocalities: nil, localities: nil)
    }

    class func mappedFilters(name: String!) -> PostFilter {
        switch(name) {
        case "NYC":
            return PostFilter(neighborhoods: nil, sublocalities: ["Manhattan", "Brooklyn", "Staten Island", "Queens", "Bronx"], localities: ["New York"])
        case "Manhattan":
            return PostFilter(neighborhoods: nil, sublocalities: ["Manhattan"], localities: nil)
        case "Brooklyn":
            return PostFilter(neighborhoods: nil, sublocalities: ["Brooklyn"], localities: nil)
        case "Staten Island":
            return PostFilter(neighborhoods: nil, sublocalities: ["Staten Island"], localities: nil)
        case "Queens":
            return PostFilter(neighborhoods: nil, sublocalities: ["Queens"], localities: nil)
        case "Bronx":
            return PostFilter(neighborhoods: nil, sublocalities: ["Bronx"], localities: nil)
        case "Everywhere Else":
            return PostFilter(neighborhoods: nil, sublocalities: ["Manhattan", "Brooklyn", "Staten Island", "Queens", "Bronx"], localities: ["New York"], negated: true)
        default:
            return PostFilter.empty()
        }
    }

    func assignToQuery(query: PFQuery) {
        if (!negated) {
            if (neighborhoods != nil) {
                query.whereKey("neighborhood", containedIn: neighborhoods)
            }
            
            if (sublocalities != nil) {
                query.whereKey("sublocality", containedIn: sublocalities)
            }
            
            if (localities != nil) {
                query.whereKey("locality", containedIn: localities)
            }
        }
        
        if (negated) {
            if (neighborhoods != nil) {
                query.whereKey("neighborhood", notContainedIn: neighborhoods)
            }
            
            if (sublocalities != nil) {
                query.whereKey("sublocality", notContainedIn: sublocalities)
            }
            
            if (localities != nil) {
                query.whereKey("locality", notContainedIn: localities)
            }
        }
    }
}