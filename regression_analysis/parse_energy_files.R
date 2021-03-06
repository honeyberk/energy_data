

require(anytime)
require(timeDate)

parse_energy_files = function(root_dir){
    # load
    
    oat = NULL
    monthly_data = NULL
    monthly_oat = NULL
    merged_df = NULL
    
    init = function(root_dir){
        oat = read.csv(file.path(root_dir, 'data', 'oat.tsv'),sep='', header=F)
        names(oat) = c('month', 'day', 'year', 'OAT')
        
        oat <<- oat
        monthly_data <<- read.csv(file.path(root_dir,'data', 'monthly_data.csv'), header=T, stringsAsFactors = F)
    }
      
    monthly_avg_oat = function(){
        monthly_oat = aggregate(oat['OAT'],by = list(oat$month,oat$year), mean)
        names(monthly_oat) = c('month', 'year', 'OAT')
        monthly_oat$end_date = as.Date(timeDate::timeLastDayInMonth(anytime::anydate(with(monthly_oat, paste(year, month)))))
        
        monthly_oat <<- monthly_oat[,3:4]
    }
    
    
    
    init(root_dir)
    monthly_avg_oat()

    return(list(oat=monthly_oat, data=monthly_data))
    
}


slice_oat_by_end_date = function(start, end, oat_df){
    oat_df[oat_df$end_date >= start & oat_df$end_date <= end,]$OAT 
}



