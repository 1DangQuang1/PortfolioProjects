select* from PortfolioProject..NashvilleDataCleaning



select CleanedSaleDate, CONVERT (date,SaleDate) 
from PortfolioProject..NashvilleDataCleaning

update NashvilleDataCleaning
set SaleDate = convert (date,SaleDate)

alter table NashvilleDataCleaning
add CleanedSaleDate date 

Update NashvilleDataCleaning
set CleanedSaleDate =  convert (date,SaleDate)



--điền dữ liệu vào PropertyAddress 
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull (a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleDataCleaning a 
join PortfolioProject..NashvilleDataCleaning b 
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where 	a.PropertyAddress is null

update a 
set a.PropertyAddress = isnull (a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleDataCleaning a 
join PortfolioProject..NashvilleDataCleaning b 
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where 	a.PropertyAddress is null




-- phân tách propertyaddress thành những cột riêng lẻ ( địa chỉ,thành phố)
select
SUBSTRING (PropertyAddress, 1 , CHARINDEX ( ',',PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress , CHARINDEX ( ',',PropertyAddress)+1, len(PropertyAddress)) as City
from PortfolioProject..NashvilleDataCleaning


alter table PortfolioProject..NashvilleDataCleaning
add Address nvarchar(255)
update PortfolioProject..NashvilleDataCleaning
set Address = SUBSTRING (PropertyAddress, 1 , CHARINDEX ( ',',PropertyAddress)-1)

alter table PortfolioProject..NashvilleDataCleaning
add SplitedCity nvarchar(255)
update PortfolioProject..NashvilleDataCleaning
set SplitedCity=SUBSTRING (PropertyAddress , CHARINDEX ( ',',PropertyAddress)+1, len(PropertyAddress))
 

 
 
 
 --cách khác ( dễ dùng hơn)

 select OwnerAddress
 from PortfolioProject..NashvilleDataCleaning

 select parsename ( replace( OwnerAddress, ',','.'),3),
 parsename ( replace( OwnerAddress, ',','.'),2),
 parsename (replace( OwnerAddress, ',','.'),1)
 from PortfolioProject..NashvilleDataCleaning

alter table PortfolioProject..NashvilleDataCleaning
add SplitedOwnerAddress nvarchar(255)
update PortfolioProject..NashvilleDataCleaning
set SplitedOwnerAddress= parsename ( replace( OwnerAddress, ',','.'),3)

alter table PortfolioProject..NashvilleDataCleaning
add SplitedOwnerCity nvarchar(255)
update PortfolioProject..NashvilleDataCleaning
set SplitedOwnerCity =  parsename ( replace( OwnerAddress, ',','.'),2)

alter table PortfolioProject..NashvilleDataCleaning
add SplitedOwnerState nvarchar(255)
update PortfolioProject..NashvilleDataCleaning
set SplitedOwnerState=  parsename ( replace( OwnerAddress, ',','.'),3)




--đổi Y,N thành Yes,No

select distinct SoldAsVacant , count (SoldAsVacant)
from PortfolioProject..NashvilleDataCleaning
group by SoldAsVacant 
order by 2

select SoldAsVacant,
case 
 when  SoldAsVacant ='Y' then 'Yes'
 when   SoldAsVacant ='N' then 'No'
 else  SoldAsVacant
end 
from PortfolioProject..NashvilleDataCleaning

 update PortfolioProject..NashvilleDataCleaning
 set  SoldAsVacant =
 case 
  when  SoldAsVacant ='Y' then 'Yes'
  when   SoldAsVacant ='N' then 'No'
  else  SoldAsVacant
 end 


 -- loại bỏ duplicates
 with NashvilleCTE as(
 select *,
 ROW_NUMBER () over ( Partition by 
 ParcelID,
 PropertyAddress,
 SaleDate,
 SalePrice,
 LegalReference
 Order by UniqueID) row_num
 from PortfolioProject..NashvilleDataCleaning)
delete  from NashvilleCTE
 where row_num>1
 


 --loại bỏ cột k dùng 
 select* from PortfolioProject..NashvilleDataCleaning

 alter table PortfolioProject..NashvilleDataCleaning
 drop column PropertyAddress, SaleDate,OwnerAddress
 alter table PortfolioProject..NashvilleDataCleaning
 drop column City
    