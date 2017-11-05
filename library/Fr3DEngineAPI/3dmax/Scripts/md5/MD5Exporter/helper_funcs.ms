-- Developed by Jonathan "BeRSeRKeR" Garcia

-- Function: strlwr
-- Description: converts a string to lower case
-- Return: the new lower cased string
-- Credits: taken from MAXScript help file
fn strlwr inStr =
(
	local outStr = copy inStr
	local upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local lower = "abcdefghijklmnopqrstuvwxyz"

	for i = 1 to outStr.count do (

		local pos = findString upper outStr[i]
		if pos != undefined do outStr[i] = lower[pos]
	)

	return outStr
)

-- Function: roundNearZeroF
-- Description: MAX uses exponential notation for numbers near zero
--				and decimal's count equal or more than 5. This function reduces
--				the decimal's count until no more exponential notation is needed
-- Return:  if "f" is near zero and decimal's count is equal or more than 5
--			returns the rounded number else returns the number itself
fn roundNearZeroF f =
(
	if (f > 0.0) and (f <= 0.00009999999) then
		do f *= 10 while f <= 0.00009999999
	else if (f >= -0.0001111111) and (f < 0.0) do
		do f *= 10 while (f >= -0.0001111111)
	
	return f
)

-- Function: roundNearZeroP2
-- Description: This function reduces the decimal's count of the Point2 components until
--				no more exponential notation is needed.
-- Return:  if "p2" components are near zero and decimal's count is equal or more than 5
--			returns the rounded Point2 else returns the point itself
fn roundNearZeroP2 p2 =
(
	for i = 1 to 2 do p2[i] = roundNearZeroF p2[i]
	return p2
)

-- Function: roundNearZeroP3
-- Description: This function reduces the decimal's count of the Point3 components until
--				no more exponential notation is needed.
-- Return:  if "p3" components are near zero and decimal's count is equal or more than 5
--			returns the rounded Point3 else returns the point itself
fn roundNearZeroP3 p3 =
(
	for i = 1 to 3 do p3[i] = roundNearZeroF p3[i]
	return p3
)

-- Function: roundNearZeroQ
-- Description: This function reduces the decimal's count of the Quat components until
--				no more exponential notation is needed.
-- Return:  if "q" components are near zero and decimal's count is equal or more than 5
--			returns the rounded Quat else returns the quaternion itself
fn roundNearZeroQ q =
(
	q.x = roundNearZeroF q.x
	q.y = roundNearZeroF q.y
	q.z = roundNearZeroF q.z
	q.w = roundNearZeroF q.w
	return q
)

-- Function: roundNearZeroM3
-- Description: This function reduces the decimal's count of the Matrix3 components until
--				no more exponential notation is needed.
-- Return:  if "m3" components are near zero and decimal's count is equal or more than 5
--			returns the rounded Matrix3 else returns the matrix itself
fn roundNearZeroM3 m3 =
(
	for i = 1 to 4 do m3[i] = roundNearZeroP3 m3[i]
	return m3
)

-- Function: roundNearZero
-- Description: This function reduces the decimal's count of the "c" numeric class
--				until no more exponential notation is needed.
-- Return:  if "c" components are near zero and decimal's count is equal or more than 5
--			returns the rounded "c" components else returns the numeric class itself
fn roundNearZero c =
(
	case (classOf c) of
	(
		Float:		return roundNearZeroF c
		Time:		return roundNearZeroF c
		Point2:		return roundNearZeroP2 c
		Point3:		return roundNearZeroP3 c
		Quat:		return roundNearZeroQ c
		Matrix3:	return roundNearZeroM3 c
		default:	return c
	)
)

-- Function: findBone
-- Description: search for "boneName" into "boneList"
-- Return:  if "boneName" is founded then returns the index of "boneName" into "boneList"
--			else returns 0
fn findBone boneList boneName =
(
	local nResult = 0
	for auxBone in boneList do
	(
		if auxBone.name == boneName do
			return (nResult += 1)
	
		nResult += 1
	)
	return 0
)

-- Function: toRightHanded
-- Description: converts a left handed matrix to right handed
-- Return:  if "m" is a left handed matrix this function returns its right handed form
-- Credits: thanks to der_ton for this one
fn toRightHanded m =
(
	local oMat

	if dot (cross m.row1 m.row2) m.row3 > 0 then
	(
		oMat = copy m
	)
	else
	(
		oMat = copy m
		oMat.row3 = -(oMat.row3)
	)

	return oMat
)