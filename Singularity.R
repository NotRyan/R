Bootstrap: docker
From: centos:7

%post
    #Install R-3.2.5
    yum install -y yum-utils epel-release wget make java-1.8.0-openjdk which
    yum-builddep -y R
    wget https://cloud.r-project.org/src/base/R-3/R-3.2.5.tar.gz
    tar -zxf R-3.2.5.tar.gz
    cd R-3.2.5
    ./configure --with-x=no
    make
    make install
    cd ..

    #Install netCDF
    wget https://github.com/Unidata/netcdf-c/archive/v4.7.0.tar.gz
    tar -zxf v4.7.0.tar.gz
    cd netcdf-c-4.7.0
    ./configure --disable-netcdf-4
    make
    make install
    cd ..

    #Install ncdf R package
    wget https://cran.r-project.org/src/contrib/Archive/ncdf/ncdf_1.6.3.tar.gz
    tar -zxf ncdf_1.6.3.tar.gz
    echo 'exportPattern( "." )' > ncdf/NAMESPACE
    tar -zcf ncdf_1.6.3_compatible.tar.gz ncdf
    R CMD INSTALL ncdf_1.6.3_compatible.tar.gz

    #Install perl requirements for gdata
    yum install -y perl
    yum install -y perl-CPAN
    cpan Module::Build
    cpan Archive::Zip Crypt::Mode::CBC Crypt::Mode::ECB Graphics::ColorUtils OLE::Storage_Lite Spreadsheet::ParseExcel
    cpan XML::Twig

    #Install packages availiable through R
    Rscript -e 'install.packages(c("gdata", "zoo", "fields"), repos="https://cloud.r-project.org")'
    Rscript -e 'install.packages(c("glmnet", "ncvreg", "doParallel"), repos="https://cloud.r-project.org")'
 
