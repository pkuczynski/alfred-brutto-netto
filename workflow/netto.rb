require 'json'

class Workflow
  def initialize query
    @params = query.split(' ')
    @subject = @params[0]

    net if @subject == 'brutto'
    gross if @subject == 'netto'
    vat
  end

  def run
    @items = []

    calculate

    item 'brutto', '%.2f' % @gross
    item 'vat', '%.2f' % @vat_amount, "VAT (#{@vat}%)"
    item 'netto', '%.2f' % @net

    @items
  end

  private

  def net
    @net = Float(@params[1].chomp('.')) rescue begin
      raise "'#{@params[1]}' nie jest poprawną kwotą"
    end
  end

  def gross
    @gross = Float(@params[1].chomp('.')) rescue begin
      raise "'#{@params[1]}' nie jest poprawną kwotą"
    end
  end

  def vat
    if @params.length > 2
      @vat = @params[2].chomp('%')

      @vat = Integer(@vat) rescue begin
        raise "'#{@params[2]}' nie jest poprawną stawką VAT"
      end
    else
      @vat = 23
    end
  end

  def item uid, value, subtitle=nil
    @items << {
        uid: uid,
        title: value,
        subtitle: subtitle ? subtitle : uid.capitalize,
        arg: JSON[{alfredworkflow: {
            arg: value,
            variables: {
                value_uid: uid
            }
        }}].to_s
    }
  end

  def calculate
    @net = @gross * 100/(100 + @vat) unless @net
    @vat_amount = @net * @vat/100 unless @vat_amount
    @gross = @net + @vat_amount unless @gross
  end

end