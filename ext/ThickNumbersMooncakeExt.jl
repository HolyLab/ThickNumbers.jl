module ThickNumbersMooncakeExt

using ThickNumbers
using Mooncake

Mooncake.tangent_type(::Type{TN}) where TN<:ThickNumber = TN
Mooncake.fdata_type(::Type{TN}) where TN<:ThickNumber = Mooncake.NoFData
Mooncake.rdata_type(::Type{TN}) where TN<:ThickNumber = TN
Mooncake.zero_rdata(x::ThickNumber) = zero(x)
Mooncake.increment_internal!!(::Mooncake.IncCache, x::TN, y::TN) where TN<:ThickNumber = x + y

end
