--ゲート・ガーディアン
function c511000916.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c511000916.spcon)
	e1:SetOperation(c511000916.spop)
	c:RegisterEffect(e1)
	--multi
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetOperation(c511000916.atkop)
	c:RegisterEffect(e2)
	--change atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c511000916.chop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)	
	e4:SetCondition(c511000916.nacon)
	e4:SetOperation(c511000916.naop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c511000916.desreptg)
	e5:SetOperation(c511000916.desrepop)
	c:RegisterEffect(e5)
end
function c511000916.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c511000916.chk,1,nil,sg,Group.CreateGroup(),25955164,62340868,98434877)
end
function c511000916.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c511000916.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c511000916.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	local g1=rg:Filter(Card.IsCode,nil,25955164)
	local g2=rg:Filter(Card.IsCode,nil,62340868)
	local g3=rg:Filter(Card.IsCode,nil,98434877)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,3,3,c511000916.rescon,0)
end
function c511000916.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,25955164,62340868,98434877)
	local sg=aux.SelectUnselectGroup(rg,e,tp,3,3,c511000916.rescon,1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
	e:GetHandler():SetMaterial(sg)
end
function c511000916.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c:GetMaterialCount()-1)
	e1:SetReset(RESET_EVENT+0x1ff0000+EVENT_ADJUST,1)
	c:RegisterEffect(e1)
end
function c511000916.matfilter(c,self)
	return self:GetFlagEffect(c:GetCode())==0
end
function c511000916.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	local tc=mat:FilterSelect(tp,c511000916.matfilter,1,1,nil,c):GetFirst()
	if not tc then return end
	c:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetTextAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c511000916.nacon(e,tp,eg,ep,ev,re,r,rp)
	local aatk=Duel.GetAttacker():GetBaseAttack()
	local catk=e:GetHandler():GetAttack()
	return aatk<=catk
end
function c511000916.naop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c511000916.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsOnField() and c:IsFaceup()
		and c:GetMaterialCount()>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(511000916,0))
end
function c511000916.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	local sg=mat:Select(tp,1,1,nil)
	mat:Sub(sg)
	c:SetMaterial(mat)
end
